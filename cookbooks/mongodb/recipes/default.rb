#
# Cookbook Name:: mongodb
# Recipe:: default
#

# Setup an arbiter on the db_master|solo as replica sets need another vote to properly failover.  If you have a Replica set > 3 nodes we don't set this up, you can tune this obviously.
case node[:kernel][:machine]
when "i686"
  ey_cloud_report "MongoDB" do
    message "You are running 386.  Switch to 64 bit to fix."
  end
  # Do nothing, you should never run MongoDB in a i686/i386 environment it will damage your data.
else
  if (['db_master','solo'].include?(@node[:instance_role]) &&  @node[:mongo_utility_instances].length < 3)
    require_recipe "mongodb::install"
    
    ey_cloud_report "MongoDB" do
      message "Installing mongodb"
    end
    
    require_recipe "mongodb::configure"
    
    ey_cloud_report "MongoDB" do
      message "Configuring mongodb"
    end
    
    require_recipe "mongodb::start"
    
    ey_cloud_report "MongoDB" do
      message "Starting mongodb"
    end
  end
  
  if (@node[:instance_role] == 'util' && @node[:name].match(/mongodb/)) || (@node[:instance_role] == "solo" &&  @node[:mongo_utility_instances].length == 0)
    require_recipe "mongodb::install"
    
    ey_cloud_report "MongoDB" do
      message "Installing mongodb"
    end
    
    require_recipe "mongodb::configure"
    
    ey_cloud_report "MongoDB" do
      message "Configuring mongodb"
    end
    
    require_recipe "mongodb::start"
    
    ey_cloud_report "MongoDB" do
      message "Starting mongodb"
    end
    if @node[:mongo_replset]
      require_recipe "mongodb::replset"
    end
  end
end

if ['app_master','app','solo'].include? @node[:instance_role]
  require_recipe "mongodb::app"
end
