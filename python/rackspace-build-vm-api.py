#!/usr/bin/python
print "Build a Rackspace VM"

import time
print "CTRL + C to exit: sleep 10"
time.sleep(10)

import logging
logging.captureWarnings(True)

import pyrax
pyrax.set_setting("identity_type", "rackspace")
pyrax.set_default_region('{region"') # replace {region} with the region of the Datacenter e.g. DFW
pyrax.set_credentials('{username}', '{apiKey}') # replace {username} & {apiKey} with your RS info

cs = pyrax.cloudservers

image = pyrax.images.get('{image#}') # replace {image#} with rs image number that you want to use
print "Server Image:"
print(image)

flavor = cs.flavors.get('2') # set the flavor variable
print "Server Flavor is ID:"
print(flavor) 
print "ENTER FLAVOR INFO IF YOU WANT e.g. 512MB Standard Instance | 512ram | 20memory | 1cpu"

server = cs.servers.create('{servername}', image.id, flavor.id) # replace {servername} with the name of the server # building server

print "building server:  please wait"
pyrax.utils.wait_for_build(server, verbose=True) # checking status of the build

print "complete"