module Metrics
  def self.included(klass)
  end

  def metrics(acw=self,options={})
    @metrics||=Metrics.new(acw,options)
  end

  class Metrics
    def initialize(acw,options={})
      @acw=acw
    end

    def method_missing(*args)
      @acw.send(*args)
    end

    def help
      puts "Available commands for Metrics :"
      puts
      puts "- list"      
    end

    def list
      
      metrics=self.connection.list_metrics()
      puts metrics.inspect
      # puts "for zone : #{self.region}#{self.zone}"
      # metrics=self.connection.get_metric_statistics(
      #   :period=>60,
      #   :start_time=>1.hour.ago,
      #   :end_time=>Time.now,
      #   :statistics=>"Average",
      #   :unit=>"Bytes/Second",
      #   :namespace=>"AWS/EC2",
      #   :measure_name=>"NetworkOut",
      #   :dimentions=>{
      #     :AvailabilityZone=>"#{self.region}#{self.zone}",
      #     :Service=>"EC2",
      #     :Namespace=>"AWS",
      #     :ImageId=>"ami-0810387c"
      #   }
      # )
      # puts metrics.inspect
      # metrics.each do |metric|
      #   puts metric.inspect
      #   puts metric.each do |m|
      #     puts m.inspect
      #   end
      #   puts
      # end
      #    :period       - x*60 seconds interval (where x > 0)
      #    :statistics   - Average, Minimum. Maximum, Sum, Samples
      #    :start_time   - The timestamp of the first datapoint to return, inclusive.
      #    :end_time     - The timestamp to use for determining the last datapoint to return. This is the last datapoint to fetch, exclusive.
      #    :namespace    - The namespace corresponding to the service of interest. For example, AWS/EC2 represents Amazon EC2.
      #    :unit         - Seconds, Percent, Bytes, Bits, Count, Bytes/Second, Bits/Second, Count/Second, and None
      #    :custom_unit  - The user-defined CustomUnit applied to a Measure. Please see the key term Unit.
      # 
      #    :dimentions
      #      Dimensions for EC2 Metrics:
      #      * ImageId              - shows the requested metric for all instances running this EC2 Amazon Machine Image(AMI)
      #      * AvailabilityZone     - shows the requested metric for all instances running in that EC2 Availability Zone
      #      * CapacityGroupName    - shows the requested metric for all instances in the specified capacity group - this dimension is
      #                               only available for EC2 metrics when the instances are in an Amazon Automatic Scaling Service
      #                               Capacity Group
      #      * InstanceId           - shows the requested metric for only the identified instance
      #      * InstanceType         - shows the requested metric for all instances running with that instance type
      #      * Service (required)   - the name of the service that reported the monitoring data - for EC2 metrics, use "EC2"
      #      * Namespace (required) - in private beta, the available metrics are all reported by AWS services, so set this to "AWS"
      #      Dimensions for Load Balancing Metrics:
      #      * AccessPointName      - shows the requested metric for the specified AccessPoint name
      #      * AvailabilityZone     - shows the requested metric for all instances running in that EC2 Availability Zone
      #      * Service (required)   - the name of the service that reported the monitoring data - for LoadBalancing metrics, use "LBS"
      #      * Namespace (required) - in private beta, the available metrics are all reported by AWS services, so set this to "AWS"
      # 
      #    :measure_name
      #      EC2 Metrics:
      #      * CPUUtilization  the percentage of allocated EC2 Compute Units that are currently in use on the instance. Units are Percent.
      #      * NetworkIn      - the number of bytes received on all network interfaces by the instance. Units are Bytes.
      #      * NetworkOut     - the number of bytes sent out on all network interfaces by the instance. Units are Bytes.
      #      * DiskReadOps    - completed read operations from all disks available to the instance in one minute. Units are Count/Second.
      #      * DiskWriteOps   - completed writes operations to all disks available to the instance in one minute. Units are Count/Second.
      #      * DiskReadBytes  - bytes read from all disks available to the instance in one minute. Units are Bytes/Second.
      #      * DiskWriteBytes - bytes written to all disks available to the instance in one minute. Units are Bytes/Second.
      #      Load Balancing Metrics:
      #      * Latency            - time taken between a request and the corresponding response as seen by the load balancer. Units are in
      #                             seconds, and the available statistics include minimum, maximum, average and count.
      #      * RequestCount       - number of requests processed by the AccessPoint over the valid period. Units are count per second, and
      #                             the available statistics include minimum, maximum and sum. A valid period can be anything equal to or
      #                             multiple of sixty (60) seconds.
      #      * HealthyHostCount   - number of healthy EndPoints for the valid Period. A valid period can be anything equal to or a multiple
      #                             of sixty (60) seconds. Units are the count of EndPoints. The meaningful statistic for HealthyHostCount
      #                             is the average for an AccessPoint within an Availability Zone. Both Load Balancing dimensions,
      #                             AccessPointName and AvailabilityZone, should be specified when retreiving HealthyHostCount.
      #      * UnHealthyHostCount - number of unhealthy EndPoints for the valid Period. A valid period can be anything equal to or a multiple
      #                             of sixty (60) seconds. Units are the count of EndPoints. The meaningful statistic for UnHealthyHostCount
      #                             is the average for an AccessPoint within Availability Amazon Monitoring Service Developer Guide Load
      #                             Balancing Metrics Version PRIVATE BETA 2009-01-22 19 Zone. Both Load Balancing dimensions, AccessPointName
      #                             and AvailabilityZone, should be specified when retreiving UnHealthyHostCount.      
    end    
  end
end

