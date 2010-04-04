require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Turnable do
  
  context 'default' do
    before(:each) do
      @turnable = Class.new do
        it_is_a Turnable
      end.new 
    end
    describe "turn_speed" do
      it "should have a defined turn_speed method" do
        lambda { @turnable.turn_speed }.should_not raise_error
      end
      it "should return the class defined turn_speed" do
        @turnable.turn_speed.should == 0.5
      end
    end
  end
  
  context 'non-default' do
    before(:each) do
      @turnable = Class.new do
        it_is_a Turnable
      
        turn_speed 1.3
      end.new
      # @turnable.rotation = 0 
    end
  
    describe "Constants" do
      it "should have turn left" do
        Turnable::Left.should == :turn_left
      end
      it "should have turn right" do
        Turnable::Right.should == :turn_right
      end
    end
  
    describe "turn_speed" do
      it "should have a defined turn_speed method" do
        lambda { @turnable.turn_speed }.should_not raise_error
      end
      it "should return the class defined turn_speed" do
        @turnable.turn_speed.should == 1.3
      end
    end
  
    describe "turn_left" do
      it "should subtract an amount from the rotation" do
        @turnable.should_receive(:rotation=).once.with -0.013
      end
    end
    describe "turn_right" do
      it "should add an amount to the rotation" do
        @turnable.should_receive(:rotation=).once.with 0.013
      end
    end
  end
  
end