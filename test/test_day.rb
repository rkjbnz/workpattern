require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/mock_date_time.rb'

class TestDay < Test::Unit::TestCase #:nodoc:

  def setup
  end
  
  must "create a working day" do
  
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
      times<<[Workpattern::Clock.new(start_hour,start_min),Workpattern::Clock.new(finish_hour,finish_min)]
    }
    
    [[24,480,Workpattern::Clock.new(9,0),Workpattern::Clock.new(23,59)]
    ].each{|hours_in_day,total,first_time,last_time|
      working_day=Workpattern::Day.new(1,hours_in_day)
      times.each{|start_time,finish_time| 
        working_day.workpattern(start_time,finish_time,0)
      } 
      assert_equal total,working_day.total, "#{hours_in_day} hour total working minutes"
      assert_equal first_time.hour, working_day.first_hour, "#{hours_in_day} hour first hour of the day"
      assert_equal first_time.min, working_day.first_min, "#{hours_in_day} hour first minute of the day"
      assert_equal last_time.hour, working_day.last_hour, "#{hours_in_day} hour last hour of the day"
      assert_equal last_time.min, working_day.last_min, "#{hours_in_day} hour last minute of the day"
    }
  end
  
  must "duplicate all of day" do
    day=Workpattern::Day.new(1,24)
    new_day = day.duplicate
    assert_equal 1440, new_day.total,"24 hour duplicate working total minutes"

    tests=[[2000,1,1,0,0,3,2000,1,1,0,3,0],
     [2000,1,1,23,59,0,2000,1,1,23,59,0],
     [2000,1,1,23,59,1,2000,1,2,0,0,0],
     [2000,1,1,23,59,2,2000,1,2,0,0,1],
     [2000,1,1,9,10,33,2000,1,1,9,43,0],
     [2000,1,1,9,10,60,2000,1,1,10,10,0],
     [2000,1,1,9,0,931,2000,1,2,0,0,31]
    ]
    clue="duplicate working pattern"
    calc_test(new_day,tests,clue)
    
    day = Workpattern::Day.new(0,24)
    new_day=day.duplicate
    assert_equal 0, new_day.total,"24 hour resting total minutes"

    tests=[[2000,1,1,0,0,3,2000,1,2,0,0,3],
     [2000,1,1,23,59,0,2000,1,1,23,59,0],
     [2000,1,1,23,59,1,2000,1,2,0,0,1],
     [2000,1,1,23,59,2,2000,1,2,0,0,2],
     [2000,1,1,9,10,33,2000,1,2,0,0,33],
     [2000,1,1,9,10,60,2000,1,2,0,0,60],
     [2000,1,1,9,0,931,2000,1,2,0,0,931]
    ]
    clue="duplicate resting pattern"
    calc_test(new_day,tests,clue)
    
    
    times=Array.new()
    [[0,0,8,59],
     [12,0,12,59],
     [17,0,22,59]
    ].each {|start_hour,start_min,finish_hour,finish_min|
      times<<[Workpattern::Clock.new(start_hour,start_min),Workpattern::Clock.new(finish_hour,finish_min)]
    }
    
    [[24,480,Workpattern::Clock.new(9,0),Workpattern::Clock.new(23,59)]
    ].each{|hours_in_day,total,first_time,last_time|
      day=Workpattern::Day.new(1,hours_in_day)
      times.each{|start_time,finish_time| 
        day.workpattern(start_time,finish_time,0)
      } 
      new_day=day.duplicate
      
      assert_equal total,new_day.total, "#{hours_in_day} hour total working minutes"
      assert_equal first_time.hour, new_day.first_hour, "#{hours_in_day} hour first hour of the day"
      assert_equal first_time.min, new_day.first_min, "#{hours_in_day} hour first minute of the day"
      assert_equal last_time.hour, new_day.last_hour, "#{hours_in_day} hour last hour of the day"
      assert_equal last_time.min, new_day.last_min, "#{hours_in_day} hour last minute of the day"
      
      new_day.workpattern(Workpattern::Clock.new(13,0),Workpattern::Clock.new(13,0),0)
      
      assert_equal total,day.total, "#{hours_in_day} hour total original working minutes"
      
      assert_equal total-1,new_day.total, "#{hours_in_day} hour total new working minutes"
      
    }
    
  end
  
  must 'add minutes in a working day' do
  
    day = Workpattern::Day.new(1)
    tests=[
     [2000,1,1,0,0,3,2000,1,1,0,3,0],
     [2000,1,1,0,0,0,2000,1,1,0,0,0],
     [2000,1,1,0,59,0,2000,1,1,0,59,0],
     [2000,1,1,0,11,3,2000,1,1,0,14,0],
     [2000,1,1,0,0,60,2000,1,1,1,0,0],
     [2000,1,1,0,0,61,2000,1,1,1,1,0],
     [2000,1,1,0,30,60,2000,1,1,1,30,0],
     [2000,12,31,23,59,1,2001,1,1,0,0,0],
     [2000,1,1,9,10,33,2000,1,1,9,43,0],
     [2000,1,1,9,10,60,2000,1,1,10,10,0],
     [2000,1,1,9,0,931,2000,1,2,0,0,31]
    ]
    clue = "add minutes in a working day"
    calc_test(day,tests,clue)
    
  end
  
  must 'add minutes in a resting day' do

    day = Workpattern::Day.new(0)
    tests=[
     [2000,1,1,0,0,3,2000,1,2,0,0,3],
     [2000,1,1,23,59,0,2000,1,1,23,59,0],
     [2000,1,1,23,59,1,2000,1,2,0,0,1],
     [2000,1,1,23,59,2,2000,1,2,0,0,2],
     [2000,1,1,9,10,33,2000,1,2,0,0,33],
     [2000,1,1,9,10,60,2000,1,2,0,0,60],
     [2000,1,1,9,0,931,2000,1,2,0,0,931]
    ]
    clue="add minutes in a resting day"
    calc_test(day,tests,clue)
  end
  
  must 'add minutes in a patterned day' do

  end
  
  must 'subtract minutes in a working day' do

    day = Workpattern::Day.new(1)
    tests=[[2000,1,1,0,0,-3,2000,1,1,0,0,-3],
     [2000,1,1,23,59,0,2000,1,1,23,59,0],
     [2000,1,1,23,59,-1,2000,1,1,23,58,0],
     [2000,1,1,23,59,-2,2000,1,1,23,57,0],
     [2000,1,1,9,10,-33,2000,1,1,8,37,0],
     [2000,1,1,9,10,-60,2000,1,1,8,10,0],
     [2000,1,1,9,0,-931,2000,1,1,0,0,-391]
    ]
    clue="subtract minutes in a working day"
    calc_test(day,tests,clue)
  end
  
  must 'subtract minutes in a resting day' do
    
    day = Workpattern::Day.new(0)
    tests=[[2000,1,1,0,0,-3,2000,1,1,0,0,-3],
     [2000,1,1,23,59,0,2000,1,1,23,59,0],
     [2000,1,1,23,59,-1,2000,1,1,0,0,-1],
     [2000,1,1,23,59,-2,2000,1,1,0,0,-2],
     [2000,1,1,9,10,-33,2000,1,1,0,0,-33],
     [2000,1,1,9,10,-60,2000,1,1,0,0,-60],
     [2000,1,1,9,0,-931,2000,1,1,0,0,-931]
    ]
    clue="subtract minutes in a resting day"
    calc_test(day,tests,clue)  
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
  
  private

  def calc_test(day,tests,clue)
    
    tests.each{|y,m,d,h,n,add,yr,mr,dr,hr,nr,rem|
      start_date=DateTime.new(y,m,d,h,n)
      result_date,remainder = day.calc(start_date,add)
      assert_equal DateTime.new(yr,mr,dr,hr,nr), result_date, "result date calc(#{start_date},#{add}) for #{clue}"
      assert_equal rem, remainder, "result remainder calc(#{start_date},#{add}) for #{clue}"  
    }
  
  
  end

end

