/* Copyright (c) 2004-2007 Sara Golemon <sarag@libssh2.org>
 * Copyright (c) 2006-2007 The Written Word, Inc.
 * Copyright (c) 2009 Daniel Stenberg
 * Copyright (C) 2008, 2009 Simon Josefsson
 * Copyright (c) 2010 Luke D Hagan
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms,
 * with or without modification, are permitted provided
 * that the following conditions are met:
 *
 *   Redistributions of source code must retain the above
 *   copyright notice, this list of conditions and the
 *   following disclaimer.
 *
 *   Redistributions in binary form must reproduce the above
 *   copyright notice, this list of conditions and the following
 *   disclaimer in the documentation and/or other materials
 *   provided with the distribution.
 *
 *   Neither the name of the copyright holder nor the names
 *   of any other contributors may be used to endorse or
 *   promote products derived from this software without
 *   specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 */

#import "SSHCore.h"

#include "libssh2_config.h"
#include "libssh2.h"
#include "libssh2_sftp.h"

#ifdef HAVE_WINSOCK2_H
# include <winsock2.h>
#endif
#ifdef HAVE_SYS_SOCKET_H
# include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
# include <netinet/in.h>
#endif
#ifdef HAVE_SYS_SELECT_H
# include <sys/select.h>
#endif
# ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_ARPA_INET_H
# include <arpa/inet.h>
#endif

#include <sys/time.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <ctype.h>

unsigned long hostaddr;
int sock;
struct sockaddr_in soin;
const char *fingerprint;
LIBSSH2_SESSION *session;
LIBSSH2_CHANNEL *channel;
int rc;
int exitcode;
int bytecount = 0;
size_t len;
LIBSSH2_KNOWNHOSTS *nh;
int type;
char *userauthlist;
char *password;
auth_pw = 0;

#define STORAGE "/tmp/sftp-storage"

// from libssh2 example - ssh2_exec.c
static int waitsocket(int socket_fd, LIBSSH2_SESSION *session)
{
    struct timeval timeout;
    int rc;
    fd_set fd;
    fd_set *writefd = NULL;
    fd_set *readfd = NULL;
    int dir;
	
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;
	
    FD_ZERO(&fd);
	
    FD_SET(socket_fd, &fd);
	
    /* now make sure we wait in the correct direction */
    dir = libssh2_session_block_directions(session);
	
    if(dir & LIBSSH2_SESSION_BLOCK_INBOUND)
        readfd = &fd;
	
    if(dir & LIBSSH2_SESSION_BLOCK_OUTBOUND)
        writefd = &fd;
	
    rc = select(socket_fd + 1, readfd, writefd, NULL, &timeout);
	
    return rc;
}

/* diff in ms */
static long tvdiff(struct timeval newer, struct timeval older)
{
	return (newer.tv_sec-older.tv_sec)*1000+
	(newer.tv_usec-older.tv_usec)/1000;
}

static void kbd_callback(const char *name, int name_len,
                         const char *instruction, int instruction_len,
                         int num_prompts,
                         const LIBSSH2_USERAUTH_KBDINT_PROMPT *prompts,
                         LIBSSH2_USERAUTH_KBDINT_RESPONSE *responses,
                         void **abstract)
{
    (void)name;
    (void)name_len;
    (void)instruction;
    (void)instruction_len;
    if (num_prompts == 1) {
        responses[0].text = strdup(password);
        responses[0].length = strlen(password);
    }
    (void)prompts;
    (void)abstract;
} /* kbd_callback */




@implementation ssh


-(id)stub_session_init
{
    [lock lock];
    return libssh2_session_init();
    usleep(100);
    [lock unlock];
    
}

-(int) initWithHost:(char *)host port:(int) p user:(char *)user password:(char *)pass {
	hostname = host;
	port = p;
	username = user;
//	key = k;
//	keypub = kpub;
	password = pass;
	
#ifdef WIN32
    WSADATA wsadata;
    WSAStartup(MAKEWORD(2,0), &wsadata);
#endif
	
    hostaddr = inet_addr(hostname);
	
    /* Ultra basic "connect to port 22 on localhost"
     * Your code is responsible for creating the socket establishing the
     * connection
     */
    sock = socket(AF_INET, SOCK_STREAM, 0);
	
    soin.sin_family = AF_INET;
    soin.sin_port = htons(port);
    soin.sin_addr.s_addr = hostaddr;
    if (connect(sock, (struct sockaddr*)(&soin),
                sizeof(struct sockaddr_in)) != 0) {
        fprintf(stderr, "failed to connect!\n");
        return -1;
    }
	
    /* Create a session instance */
    session = [self stub_session_init];
    //session = libssh2_session_init();
    if (!session)
        return -1;
	
    /* tell libssh2 we want it all done non-blocking */
//    libssh2_session_set_blocking(session, 0);
	
    /* ... start it up. This will trade welcome banners, exchange keys,
     * and setup crypto, compression, and MAC layers
     */
    while ((rc = libssh2_session_startup(session, sock)) ==
           LIBSSH2_ERROR_EAGAIN);
    if (rc) {
        fprintf(stderr, "Failure establishing SSH session: %d\n", rc);
        return -1;
    }
	
    nh = libssh2_knownhost_init(session);
    if(!nh) {
        /* eeek, do cleanup here */
        return 2;
    }
	
    /* read all hosts from here */
    libssh2_knownhost_readfile(nh, "known_hosts",
                               LIBSSH2_KNOWNHOST_FILE_OPENSSH);
	
    /* store all known hosts to here */
    libssh2_knownhost_writefile(nh, "dumpfile",
                                LIBSSH2_KNOWNHOST_FILE_OPENSSH);
	
 //   fingerprint = libssh2_session_hostkey(session, &len, &type);
    userauthlist = libssh2_userauth_list(session, username, strlen(username));
    printf("Authentication methods: %s\n", userauthlist);
    if (strstr(userauthlist, "password") != NULL) {
        auth_pw |= 1;
    }
    if (strstr(userauthlist, "keyboard-interactive") != NULL) {
        auth_pw |= 2;
    }
    if (strstr(userauthlist, "publickey") != NULL) {
        auth_pw |= 4;
    }

    
    
    
    fingerprint = libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1);
    printf("Fingerprint: ");
    for(int i = 0; i < 20; i++) {
        printf("%02X ", (unsigned char)fingerprint[i]);
    }
    printf("\n");
    if(fingerprint) {
        struct libssh2_knownhost *host;
        int check = libssh2_knownhost_check(nh, (char *)hostname,
                                            (char *)fingerprint, len,
                                            LIBSSH2_KNOWNHOST_TYPE_PLAIN|
                                            LIBSSH2_KNOWNHOST_KEYENC_RAW,
                                            &host);
		
       fprintf(stderr, "", check,
                (check <= LIBSSH2_KNOWNHOST_CHECK_MISMATCH)?
                host->key:"<none>");
		
        /*****
         * At this point, we could verify that 'check' tells us the key is
         * fine or bail out.
         *****/
    }
    else {
        /* eeek, do cleanup here */
        return 3;
    }
    libssh2_knownhost_free(nh);
	
    if (auth_pw & 1) {
        /* We could authenticate via password */
        if (libssh2_userauth_password(session, username, password)) {
            printf("\tAuthentication by password failed!\n");
     //       goto shutdown;
        } else {
            printf("\tAuthentication by password succeeded.\n");
        }
    } else if (auth_pw & 2) {
        /* Or via keyboard-interactive */
        if (libssh2_userauth_keyboard_interactive(session, username,
                                                  &kbd_callback) ) {
            printf("\tAuthentication by keyboard-interactive failed!\n");
     //       goto shutdown;
        } else {
            printf("\tAuthentication by keyboard-interactive succeeded.\n");
        }
    }


  /*  if ( strlen(password) != 0 ) {
		/* We could authenticate via password */
      /*  while ((rc = libssh2_userauth_password(session, username, password)) ==
			   LIBSSH2_ERROR_EAGAIN);
		if (rc) {
			fprintf(stderr, "Authentication by password failed.\n");
			return 1;
		}
	}
	else {
		/* Or by public key */
	/*	while ((rc = libssh2_userauth_publickey_fromfile(session, username, keypub, key, password)) == LIBSSH2_ERROR_EAGAIN);
		if (rc) {
			fprintf(stderr, "\tAuthentication by public key failed\n");
			return 1;
		}*/
		//}
		
#if 0
		libssh2_trace(session, ~0 );
#endif
		
	//}
	return 0;
}

// from libssh2 example - ssh2_exec.c
-(NSString*) execCommand: (char *)commandline {
	NSMutableString *result = [[NSString alloc] init];
//	libssh2_session_set_blocking(session,0);
    /* Exec non-blocking on the remove host */
    while( (channel = libssh2_channel_open_session(session)) == NULL &&
		  libssh2_session_last_error(session,NULL,NULL,0) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    if( channel == NULL )
    {
        fprintf(stderr,"Error\n");
        exit( 1 );
    }
    while( (rc = libssh2_channel_exec(channel, commandline)) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    if( rc != 0 )
    {
        fprintf(stderr,"Error\n");
        exit( 1 );
    }
    for( ;; )
    {
        /* loop until we block */
        int rc1;
        do
        {
            char buffer[0x4000];
            rc1 = libssh2_channel_read( channel, buffer, sizeof(buffer) );
            if( rc1 > 0 )
            {
				result = [result stringByAppendingString:[NSString stringWithCString:buffer encoding: 4]];
				result = [result stringByAppendingString:@"\n"];
                int i;
                bytecount += rc1;
  //              fprintf(stderr, "We read:\n");
             //   for( i=0; i < rc1; ++i )
               //     fputc( buffer[i], stderr);
              //  fprintf(stderr, "\n");
            }
            else {
				rc1 = libssh2_channel_read( channel, buffer, sizeof(buffer) );
           //     fprintf(stderr, "libssh2_channel_read returned %d\n", rc1);
            }
        }
        while( rc1 > 0 );
		
        /* this is due to blocking that would occur otherwise so we loop on
		 this condition */
        if( rc1 == LIBSSH2_ERROR_EAGAIN )
        {
            waitsocket(sock, session);
        }
        else
            break;
    }
    exitcode = 127;
    while( (rc = libssh2_channel_close(channel)) == LIBSSH2_ERROR_EAGAIN )
        waitsocket(sock, session);
	
    if( rc == 0 )
    {
        exitcode = libssh2_channel_get_exit_status( channel );
    }
 //   printf("\nEXIT: %d bytecount: %d\n", exitcode, bytecount);
	
    libssh2_channel_free(channel);
    channel = NULL;
	
    return result;

}
-(void) setCommand:(char *)command
{
	commandline = command;
}
-(void) setController:(id)control
{
    controller = control;
}

-(void) execWithController:(id) control {
	
	NSAutoreleasePool * pool;
    
    pool = [[NSAutoreleasePool alloc] init];
	commandline = [[control objectAtIndex:1] UTF8String];
	//NSString *result = [[NSString alloc] init];
	//libssh2_session_set_blocking(session,0);
    /* Exec non-blocking on the remove host */
    
    while( (channel = libssh2_channel_open_session(session)) == NULL &&
		  libssh2_session_last_error(session,NULL,NULL,0) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    
    if( channel == NULL )
    {
  //      fprintf(stderr,"Error\n");
        exit( 1 );
    }
    
    while( (rc = libssh2_channel_exec(channel, commandline)) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket(sock, session);
    }
    
    if( rc != 0 )
    {
  //      fprintf(stderr,"Error\n");
        exit( 1 );
    }
    for( ;; )
    {
        /* loop until we block */
        int rc;
        do
        {
          //  libssh2_session_set_blocking(session, 0);
            
              char buffer[0x4000];
            
           // char *buffer = (char*)malloc(40*sizeof(char));
            // if( channel != NULL )
          //  NSLog(@"%d",channel);
           
          //  NSLog(@"%d",[[control objectAtIndex:2] intValue]);
            
            rc = libssh2_channel_read_ex( channel, 0, buffer, sizeof(buffer) );
            
            if( rc > 0 )
            {
				
             //   NSLog(@"%s",buffer);
                
                int i;
                bytecount += rc;
                
				//              fprintf(stderr, "We read:\n");
			//	char output[(rc-1)];   
             //   for( i=0; i < rc; ++i )
               //     output[i] = buffer[i];
                char *cmd_contents;
                if(cmd_contents){
                    free(cmd_contents);
                }
                
                
                cmd_contents = (char*)malloc(sizeof(buffer));
                strcpy(cmd_contents, buffer);
                //NSLog(@"%s",buffer);
                [[control objectAtIndex:0] performSelectorOnMainThread:@selector(processActiveResult:) withObject:[NSString stringWithCString:cmd_contents encoding: 4] waitUntilDone:NO];
              //  free(buffer);
               
                if( rc == LIBSSH2_ERROR_EAGAIN ) { waitsocket(sock, session); }
               
               // result = [result stringByAppendingString:[NSString stringWithCString:output encoding: 4]];
			//	result = [result stringByAppendingString:@"\n"];
                   //    fputc( buffer[i], stderr);
				 // fprintf(stderr, "\n");
            }
       /*     else {
				
                if( (libssh2_channel_open_session(session)) == NULL &&
                      libssh2_session_last_error(session,NULL,NULL,0) ==
                      LIBSSH2_ERROR_EAGAIN )
                {
                    waitsocket(sock, session);
                }
                rc1 = libssh2_channel_read( channel, buffer, sizeof(buffer) );
				//     fprintf(stderr, "libssh2_channel_read returned %d\n", rc1);
            }*/
        }
        while( rc > 0 );
		
        /* this is due to blocking that would occur otherwise so we loop on
		 this condition */
        
        if( rc == LIBSSH2_ERROR_EAGAIN )
        {
            waitsocket(sock, session);
        }
        
        else
            break;
         
    }
    exitcode = 127;
    
    if( channel != NULL )
    {
    while( (rc = libssh2_channel_close(channel)) == LIBSSH2_ERROR_EAGAIN )
        waitsocket(sock, session);
	}
    
    
    if( rc == 0 )
    {
        exitcode = libssh2_channel_get_exit_status( channel );
    }
   
 //   printf("\nEXIT: %d bytecount: %d\n", exitcode, bytecount);
	
    libssh2_channel_free(channel);
    
  //  channel = NULL;
	
   // libssh2_channel_free(channel); // freeup memory channel = NULL;
  //  [[control objectAtIndex:0] performSelectorOnMainThread:@selector(processResult:) withObject:result waitUntilDone:NO];
	
    [pool drain];
}




-(NSString*) receiveSCP: (char *)scppath {
	NSString* result;
	struct stat fileinfo;
	struct timeval start;
	struct timeval end;
	int total = 0;
	long time_ms;
	int spin = 0;
#if defined(HAVE_IOCTLSOCKET)
	long flag = 1;
#endif
	off_t got=0;
	
	/* Request a file via SCP */
    fprintf(stderr, "libssh2_scp_recv()!\n");
    do {
        channel = libssh2_scp_recv(session, scppath, &fileinfo);
		
        if (!channel) {
            if(libssh2_session_last_errno(session) != LIBSSH2_ERROR_EAGAIN) {
                char *err_msg;
				
                libssh2_session_last_error(session, &err_msg, NULL, 0);
                fprintf(stderr, "%s\n", err_msg);
                return Nil;
            }
            else {
                fprintf(stderr, "libssh2_scp_recv() spin\n");
                waitsocket(sock, session);
            }
        }
    } while (!channel);
    fprintf(stderr, "libssh2_scp_recv() is done, now receive data!\n");
	
    while(got < fileinfo.st_size) {
        char mem[1024*24];
        int rc;
		
        do {
            int amount=sizeof(mem);
			
            if ((fileinfo.st_size -got) < amount) {
                amount = fileinfo.st_size - got;
            }
			
            /* loop until we block */
            rc = libssh2_channel_read(channel, mem, amount);
            if (rc > 0) {
                write(1, mem, rc);
				result = [NSString stringWithCString:mem encoding: 4];
                got += rc;
                total += rc;
            }
        } while (rc > 0);
		
        if ((rc == LIBSSH2_ERROR_EAGAIN) && (got < fileinfo.st_size)) {
            /* this is due to blocking that would occur otherwise
			 so we loop on this condition */
			
            spin++;
            waitsocket(sock, session); /* now we wait */
            continue;
        }
        break;
    }
	
    gettimeofday(&end, NULL);
	
    time_ms = tvdiff(end, start);
    printf("Got %d bytes in %ld ms = %.1f bytes/sec spin: %d\n", total,
           time_ms, total/(time_ms/1000.0), spin );
	
	
	
    libssh2_channel_free(channel);
    channel = NULL;
	
	return result;
}

-(int) sendSCPfile:(char *)loclfile dest:(char *)scppath {
	FILE *local;
    int rc;
#if defined(HAVE_IOCTLSOCKET)
    long flag = 1;
#endif
    char mem[1024];
    size_t nread, sent;
    char *ptr;
    struct stat fileinfo;
	
	local = fopen(loclfile, "rb");
    if (!local) {
        fprintf(stderr, "Can't local file %s\n", loclfile);
        return 1;
    }
	
    stat(loclfile, &fileinfo);
	
	/* Send a file via scp. The mode parameter must only have permissions! */
    do {
        channel = libssh2_scp_send(session, scppath, fileinfo.st_mode & 0777,
                                   (unsigned long)fileinfo.st_size);
		
        if ((!channel) && (libssh2_session_last_errno(session) !=
                           LIBSSH2_ERROR_EAGAIN)) {
            char *err_msg;
			
            libssh2_session_last_error(session, &err_msg, NULL, 0);
            fprintf(stderr, "%s\n", err_msg);
            return 1;
        }
    } while (!channel);
	
    fprintf(stderr, "SCP session waiting to send file\n");
    do {
        nread = fread(mem, 1, sizeof(mem), local);
        if (nread <= 0) {
            /* end of file */
            break;
        }
        ptr = mem;
        sent = 0;
		
        do {
            /* write the same data over and over, until error or completion */
            rc = libssh2_channel_write(channel, ptr, nread);
            if (LIBSSH2_ERROR_EAGAIN == rc) { /* must loop around */
                continue;
            } else if (rc < 0) {
                fprintf(stderr, "ERROR %d\n", rc);
            } else {
                /* rc indicates how many bytes were written this time */
                sent += rc;
            }
        } while (rc > 0 && sent < nread);
        ptr += sent;
        nread -= sent;
    } while (1);
	
    fprintf(stderr, "Sending EOF\n");
    while (libssh2_channel_send_eof(channel) == LIBSSH2_ERROR_EAGAIN);
	
    fprintf(stderr, "Waiting for EOF\n");
    while (libssh2_channel_wait_eof(channel) == LIBSSH2_ERROR_EAGAIN);
	
    fprintf(stderr, "Waiting for channel to close\n");
    while (libssh2_channel_wait_closed(channel) == LIBSSH2_ERROR_EAGAIN);
	
    libssh2_channel_free(channel);
    channel = NULL;
	
	return 0;
}

-(NSMutableArray*) dirSFTP:(char *)sftppath {
	NSMutableArray* result;
	result = [[NSMutableArray alloc] init];
	
	LIBSSH2_SFTP *sftp_session;
    LIBSSH2_SFTP_HANDLE *sftp_handle;
	
	do {
        sftp_session = libssh2_sftp_init(session);
		
        if ((!sftp_session) && (libssh2_session_last_errno(session) !=
                                LIBSSH2_ERROR_EAGAIN)) {
            fprintf(stderr, "Unable to init SFTP session\n");
            //goto shutdown;
        }
    } while (!sftp_session);
	
	/* Request a dir listing via SFTP */
    do {
        sftp_handle = libssh2_sftp_opendir(sftp_session, sftppath);
		
        if ((!sftp_handle) && (libssh2_session_last_errno(session) !=
                               LIBSSH2_ERROR_EAGAIN)) {
            fprintf(stderr, "Unable to open dir with SFTP\n");
            //goto shutdown;
        }
    } while (!sftp_handle);
	
    fprintf(stderr, "libssh2_sftp_opendir() is done, now receive listing!\n");
    do {
        char mem[512];
        LIBSSH2_SFTP_ATTRIBUTES attrs;
		
        /* loop until we fail */
        while ((rc = libssh2_sftp_readdir(sftp_handle, mem, sizeof(mem),
                                          &attrs)) == LIBSSH2_ERROR_EAGAIN) {
            ;
        }
        if(rc > 0) {
            /* rc is the length of the file name in the mem
			 buffer */
			
            if(attrs.flags & LIBSSH2_SFTP_ATTR_PERMISSIONS) {
                /* this should check what permissions it
				 is and print the output accordingly */
                printf("--fix----- ");
            } else {
                printf("---------- ");
            }
			
            if(attrs.flags & LIBSSH2_SFTP_ATTR_UIDGID) {
                printf("%4ld %4ld ", attrs.uid, attrs.gid);
            } else {
                printf("   -    - ");
            }
			
            if(attrs.flags & LIBSSH2_SFTP_ATTR_SIZE) {
                /* attrs.filesize is an uint64_t according to
				 the docs but there is no really good and
				 portable 64bit type for C before C99, and
				 correspondingly there was no good printf()
				 option for it... */
				
                printf("%8lld ", attrs.filesize);
            }
			
            printf("%s\n", mem);
			[result addObject:[NSString stringWithCString:mem encoding: 4]];
			
        }
        else if (rc == LIBSSH2_ERROR_EAGAIN) {
            /* blocking */
            fprintf(stderr, "Blocking\n");
        } else {
            break;
        }
		
    } while (1);
	
    libssh2_sftp_closedir(sftp_handle);
    libssh2_sftp_shutdown(sftp_session);
	
	return result;
}


-(NSString*) receiveSFTP:(char *)sftppath {
	FILE *tempstorage;
    char mem[4096];
	struct timeval timeout;
    fd_set fd;
	
	LIBSSH2_SFTP *sftp_session;
    LIBSSH2_SFTP_HANDLE *sftp_handle;
	
	tempstorage = fopen(STORAGE, "wb");
    if(!tempstorage) {
        printf("Can't open temp storage file %s\n", STORAGE);
        //goto shutdown;
    }
	
    sftp_session = libssh2_sftp_init(session);
	
	do {
        sftp_session = libssh2_sftp_init(session);
		
        if ((!sftp_session) && (libssh2_session_last_errno(session) !=
                                LIBSSH2_ERROR_EAGAIN)) {
            fprintf(stderr, "Unable to init SFTP session\n");
            //goto shutdown;
        }
    } while (!sftp_session);
	
    /* Request a file via SFTP */
	
	do {
		sftp_handle = libssh2_sftp_open(sftp_session, sftppath, LIBSSH2_FXF_READ, 0);
		
		if (!sftp_handle) {
			fprintf(stderr, "Unable to open file with SFTP\n");
			//goto shutdown;
		}
		fprintf(stderr, "libssh2_sftp_open() is done, now receive data!\n");
    } while (!sftp_handle);
	
	NSMutableString* result;
	result = [NSMutableString stringWithFormat:@""];
	NSString* data;
	
    do {
        do {
            /* read in a loop until we block */
            rc = libssh2_sftp_read(sftp_handle, mem, sizeof(mem));
            //fprintf(stderr, "libssh2_sftp_read returned %d\n", rc);
			
            if(rc > 0) {
                /* write to stderr */
                //write(2, mem, rc);
                /* write to temporary storage area */
                fwrite(mem, rc, 1, tempstorage);
				// not sure why this is necessary, mem wouldn't convert to NSString otherwise
				data = [[NSString alloc] initWithFormat:@"%s", mem];
				[result appendString:(data == nil ? @"" : data)];
            }
        } while (rc > 0);
		
        if(rc != LIBSSH2_ERROR_EAGAIN) {
            /* error or end of file */
            break;
        }
		
        timeout.tv_sec = 10;
        timeout.tv_usec = 0;
		
        FD_ZERO(&fd);
		
        FD_SET(sock, &fd);
		
        /* wait for readable or writeable */
        rc = select(sock+1, &fd, &fd, NULL, &timeout);
        if(rc <= 0) {
            /* negative is error
			 0 is timeout */
            fprintf(stderr, "SFTP download timed out: %d\n", rc);
            break;
        }
		
    } while (1);
	
    libssh2_sftp_close(sftp_handle);
	fclose(tempstorage);
	
	tempstorage = fopen(STORAGE, "rb");
    if(!tempstorage) {
        /* weird, we can't read the file we just wrote to... */
        fprintf(stderr, "can't open %s for reading\n", STORAGE);
        //goto shutdown;
    }
	
	return result;
}


-(int) sendFTP:(char *)dest {
	LIBSSH2_SFTP *sftp_session;
    LIBSSH2_SFTP_HANDLE *sftp_handle;
	FILE *tempstorage;
	char mem[1000];
	struct timeval timeout;
    fd_set fd;
	
    tempstorage = fopen(STORAGE, "rb");
    if(!tempstorage) {
        /* weird, we can't read the file we just wrote to... */
        fprintf(stderr, "can't open %s for reading\n", STORAGE);
        //goto shutdown;
    }
	
    /* we're done downloading, now reverse the process and upload the
	 temporarily stored data to the destination path */
    sftp_handle =
	libssh2_sftp_open(sftp_session, dest,
					  LIBSSH2_FXF_WRITE|LIBSSH2_FXF_CREAT,
					  LIBSSH2_SFTP_S_IRUSR|LIBSSH2_SFTP_S_IWUSR|
					  LIBSSH2_SFTP_S_IRGRP|LIBSSH2_SFTP_S_IROTH);
    if(sftp_handle) {
        size_t nread;
        char *ptr;
        do {
            nread = fread(mem, 1, sizeof(mem), tempstorage);
            if(nread <= 0) {
                /* end of file */
                break;
            }
            ptr = mem;
			
            do {
                /* write data in a loop until we block */
                rc = libssh2_sftp_write(sftp_handle, ptr,
                                        nread);
                ptr += rc;
                nread -= nread;
            } while (rc > 0);
			
            if(rc != LIBSSH2_ERROR_EAGAIN) {
                /* error or end of file */
                break;
            }
			
            timeout.tv_sec = 10;
            timeout.tv_usec = 0;
			
            FD_ZERO(&fd);
			
            FD_SET(sock, &fd);
			
            /* wait for readable or writeable */
            rc = select(sock+1, &fd, &fd, NULL, &timeout);
            if(rc <= 0) {
                /* negative is error
				 0 is timeout */
                fprintf(stderr, "SFTP upload timed out: %d\n",
                        rc);
                break;
            }
        } while (1);
        fprintf(stderr, "SFTP upload done!\n");
    }
    else {
        fprintf(stderr, "SFTP failed to open destination path: %s\n",
                dest);
    }
	
    libssh2_sftp_shutdown(sftp_session);
	
	return 0;
}

	
-(int) closeSSH {	
    libssh2_session_disconnect(session,
                               "Normal Shutdown, Thank you for playing");
    libssh2_session_free(session);
	
#ifdef WIN32
    closesocket(sock);
#else
    close(sock);
#endif
    fprintf(stderr, "all done\n");
	
	return 0;
}
	
-(void) libssh2ver {
	NSString *version = [NSString stringWithCString:libssh2_version(0) encoding: 4];
	NSLog(@"We are using libssh2 version: %@", version);
}

- (void)dealloc
{
    
    //  [super dealloc];
}

@end
