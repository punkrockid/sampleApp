require "spec_helper"

describe ApplicationHelper do
	describe "full_title" do
		it "should include the page name" do
			full_title("blah").should =~ /blah/
		end

		it "should include the base name" do
			full_title("blah").should =~ /^ROR Sample App/
		end

		it "should not include a bar on the home page title" do
			full_title("").should_not =~ /\|/
		end
	end
end