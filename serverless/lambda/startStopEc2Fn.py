import boto3
import time
##
# First function will try to filter for EC2 instances that contain a tag named `schedulestopstart` which is set to `true` and tag named `env` is set to `dev`

# In order to trigger this function make sure to setup CloudWatch event which will be executed every minute. 
# Following Lambda Function needs a role with permission to start and stop EC2 instances and writhe to CloudWatch logs.
# p
# Example EC2 Instance tags: 
# 
#  schedulestopstart     : true
#  env                   : dev
##
#define boto3 the connection
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    
    # Get current time in format H:M
    current_time = time.strftime("%H:%M")
    
    # Find all the instances that are tagged with Scheduled:True
    filters = [{
            'Name': 'tag:schedulestopstart',
            'Values': ['true']
        }
    ]
    # Search all the instances which contains scheduled filter 
    instances = ec2.instances.filter(Filters=filters)
    
    startInstances = []  
    # Locate all instances that are tagged to start or stop.
    for instance in instances:
            
        for tag in instance.tags:
            if tag['Key'] == 'env':
                if tag['Value'] == 'dev':
                    startInstances.append(instance.id)
                    pass
                pass
            pass
        pass
    
    print (current_time)
    
   
    if len(startInstances) > 0:
        # perform the start
        if event['action'] == 'start':
            response = ec2.instances.filter(InstanceIds=startInstances).start()
            print (response)
        elif event['action'] == 'stop':
            response = ec2.instances.filter(InstanceIds=startInstances).stop()
            print (response)
        else:
            print ("No Action")
    else:
        print ("No instances to start.")
