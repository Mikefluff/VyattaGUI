//
//  Expecter.m
//  data_m
//
//  Created by Mike Fluff on 09.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "Expecter.h"


	

@implementation Expecter
//FILE *fp;


void endup()
{
	fprintf(fp,"\n");
	exp_fexpectl(fp,
				 exp_glob,"[edit]",0,
				 exp_end);
}
void timedout()
{
	fprintf(stderr,"timed outn");
	exit(-1);
}

void commit()
{
	fprintf(fp,"commit");
	endup();
	
}



	

-(int) initWithHost:(char *)host port:(int) p user:(char *)user password:(char *)pass {
	hostname = host;
	port = p;
	username = user;
	password = pass;
	
	
	
	exp_loguser = 0; // don't echo to terminal
	exp_timeout = 3600; // arbitrary, you may change it for each interaction
	
	
	if (NULL == (fd = exp_spawnl("/usr/bin/ssh","/usr/bin/ssh","-l",username,"-o UserKnownHostsFile=/dev/null","-o StrictHostKeyChecking=no",host,NULL))) {
		perror("ftp");
		exit(-1);
	}
    
	if (NULL == (fp = fdopen(fd,"r+"))) // mainly to be able to use printf instead of write...
		return(0);
    setbuf(fp,(char *)0);
	
	if (EXP_TIMEOUT == exp_fexpectl(fp,
									exp_glob,"word:",0,
									exp_end)) {
		timedout();
	}
	
	fprintf(fp,username);
	fprintf(fp,"\n");
	
	exp_fexpectl(fp,
				 exp_glob,"vyatta:",0,
				 exp_end)		;
	
	
	
	fprintf(fp,"configure");
	endup();
	
	return 0;
	
}
-(int) execCommand: (NSString *)commandline
{
	[self execParamCommand:commandline parameter:nil];
}

-(int) execParamCommand: (NSString *)commandline parameter:(id)param;
{
	if(param==nil)
	{
		char *cmd;
		
		cmd = [commandline UTF8String];
		printf("%s",cmd);
		fprintf(fp,cmd);
		endup();
		
		commit();
	}
	
		
	
	return 0;
	
}
@end
