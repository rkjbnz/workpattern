require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/mock_date_time.rb'

class TestDay < Test::Unit::TestCase #:nodoc:

  def setup
  end
  
  must "ceate a working day" do
    working_day = Workpattern::Day.new(1,24)
    assert_equal 1440, working_day.total,"24 hour working total minutes"
    
    working_day = Workpattern::Day.new(1,23)
    assert_equal 1380, working_day.total,"23 hour working total minutes"
    
    working_day = Workpattern::Day.new(1,25)
    assert_equal 1500, working_day.total,"25 hour working total minutes"
    
    working_day = Workpattern::Day.new(1,3)
    assert_equal 180, working_day.total,"3 hour working total minutes"
  end
    
  must "ceate a resting day" do
    resting_day = Workpattern::Day.new(0,24)
    assert_equal 0, resting_day.total,"24 hour resting total minutes"
    
    resting_day = Workpattern::Day.new(0,23)
    assert_equal 0, resting_day.total,"23 hour resting total minutes"
    
    resting_day = Workpattern::Day.new(0,25)
    assert_equal 0, resting_day.total,"25 hour resting total minutes"
    
    resting_day = Workpattern::Day.new(0,3)
    assert_equal 0, resting_day.total,"3 hour resting total minutes"
  end
  
  must "set patterns correctly" do
    
    times=Array.new()
    [[0,0,8,59],
     [12,0,12,59],
     [17,0,22,59]
    ].each {|start_hour,start_min,finish_hour,finish_min|
      times<<[Workpattern::MockDateTime.new(2011,1,1,start_hour,start_min),Workpattern::MockDateTime.new(2011,1,1,finish_hour,finish_min)]
    }
    
    [[24,480,Workpattern::MockDateTime.new(1963,10,6,9,0),Workpattern::MockDateTime.new(1963,10,6,23,59)],
     [23,420,Workpattern::MockDateTime.new(1963,10,6,9,0),Workpattern::MockDateTime.new(1963,10,6,16,59)],
     [25,540,Workpattern::MockDateTime.new(1963,10,6,9,0),Workpattern::MockDateTime.new(1963,10,6,24,59)]
    ].each{|hours_in_day,total,first_time,last_time|
      working_day=Workpattern::Day.new(1,hours_in_day)
      times.each{|start_time,finish_time| 
        working_day.workpattern(start_time.hour,start_time.min,finish_time.hour,finish_time.min,0)
      } 
      assert_equal total,working_day.total, "#{hours_in_day} hour total working minutes"
      assert_equal first_time.hour, working_day.first_hour, "#{hours_in_day} hour first hour of the day"
      assert_equal first_time.min, working_day.first_min, "#{hours_in_day} hour first minute of the day"
      assert_equal last_time.hour, working_day.last_hour, "#{hours_in_day} hour last hour of the day"
      assert_equal last_time.min, working_day.last_min, "#{hours_in_day} hour last minute of the day"
    }
  end
  
  must 'add minutes in a working day' do
  
    working_day = Workpattern::Day.new(1)
    [[0,0,3,0,3,0],
     [23,59,0,23,59,0],
     [23,59,1,23,60,0],
     [23,59,2,23,60,1],
     [9,10,33,9,43,0],
     [9,10,60,10,10,0],
     [9,0,931,23,60,31]
    ].each{|start_hour,start_min,duration,result_hour,result_min,result_remainder|
      hour,min,remainder = working_day.calc(start_hour,start_min,duration)
      assert_equal result_hour, hour, "result calc(#{start_hour},#{start_min},#{duration})"
      assert_equal result_min, min, "result calc(#{start_hour},#{start_min},#{duration})"
      assert_equal result_remainder, remainder, "result calc(#{start_hour},#{start_min},#{duration})"      
    }
    
  end
  
  must 'add minutes in a resting day' do
  
    
  end
  
  must 'add minutes in a patterned day' do
    
  end
  
  must 'subtract minutes in a working day' do

  end
  
  must 'subtract minutes in a resting day' do
  end
  
  must 'subtract minutes in a patterned day' do
 
  end
  
  
  must 'create complex patterns' do
 
  end

  must "calculate difference between times in working day" do

  end

  must "calculate difference between minutes in resting day" do
    
  end

  must "calculate difference between minutes in pattern day" do

  end

end

