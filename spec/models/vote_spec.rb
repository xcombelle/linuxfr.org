require 'spec_helper'

describe Vote do
  before(:each) do
    @user = Factory(:user)
    @node = Factory(:node)
  end

  it "should create a new instance when an user votes for a node" do
    Vote.for(@user, @node)
    @user.votes.count.should == 1
    @node.reload.score.should == 1
  end

  it "should create a new instance when an user votes against a node" do
    Vote.against(@user, @node)
    @user.votes.count.should == 1
    @node.reload.score.should == -1
  end

  it "should not possible for an user to change his mind" do
    Vote.against(@user, @node)
    Vote.for(@user, @node)
    @user.votes.count.should == 1
    @node.reload.score.should == 1
  end

  it "should be idempotent" do
    3.times { Vote.for(@user, @node) }
    @user.votes.count.should == 1
    @node.reload.score.should == 1
  end

  it "should decrement the number of votes for the user" do
    Account.update_all(:nb_votes => 10)
    Vote.for(@user, @node)
    Account.where(:user_id => @user.id).first.nb_votes.should == 9
  end
end