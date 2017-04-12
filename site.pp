## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
File { backup => false }

# App Orchestration

site {

  $webver = 1
  bluegreen { 'tiered':
    awsnodes => [ 'bluegreen-database', "bluegreen-web${webver}-1", "bluegreen-web${webver}-2", 'bluegreen-lb'],
    nodes => {
      Node['ip-10-98-10-154.us-west-2.compute.internal'] => [ Bluegreen::Nodes['awsproxy'], Bluegreen::Verify['awsverify'] ],
      Node['bluegreen-database'] => Bluegreen::Database['database'],
      Node["bluegreen-web${webver}-1"] => Bluegreen::Web["web${webver}-1"],
      Node["bluegreen-web${webver}-2"] => Bluegreen::Web["web${webver}-2"],
      Node['bluegreen-lb'] => Bluegreen::Lb['loadbalancer'],
    }
  }

}
# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
