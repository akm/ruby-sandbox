# -*- coding: utf-8 -*-
require 'spec_helper'

class Person
  include Mongoid::Document
  references_one :policy
  references_many :prescriptions
  references_many :preferences, :stored_as => :array, :inverse_of => :people
end

class Policy
  include Mongoid::Document
  referenced_in :person
end

class Prescription
  include Mongoid::Document
  referenced_in :person
end

class Preference
  include Mongoid::Document
  references_many :people, :stored_as => :array, :inverse_of => :preferences
end


describe "relational associations" do

  describe "Policy#person", "Person#policy" do
    before do
      Person.delete_all
      Policy.delete_all
    end

    {
      "both saved" => lambda{ @person = Person.create; @policy = Policy.create},
      "Policy not saved" => lambda{ @person = Person.create; @policy = Policy.new},
      # "both not saved" => lambda{ @person = Person.new; @policy = Policy.new},
    }.each do |precondition_name, precondition_lambda|
      context(precondition_name) do
        before(&precondition_lambda)

        {
          "when Policy#person_id= is used" => lambda{@policy.person_id = @person.id; @policy.save!},
          "when Policy#person= is used"    => lambda{@policy.person = @person; @policy.save!},
          "when Person#policy= is used"    => lambda{@person.policy = @policy; @policy.save!},
        }.each do |context_desc, before_lambda|
          context(context_desc) do
            before(&before_lambda)

            it "Policy#person_id " do
              @policy.person_id.should == @person.id
            end
            it "リロードしてもOK" do
              policy = Policy.find(@policy.id)
              policy.person_id.should == @person.id
            end
            it "Person#policyでも取得できるべき" do
              person = Person.find(@person.id)
              person.policy.id.should == @policy.id
            end
            it "@personは保存されている" do
              @person.id.should_not be_nil
            end
            it "@policyは保存されている" do
              @policy.id.should_not be_nil
            end
          end
        end

      end
    end
  end

  describe "Prescription#person", "Person#prescriptions" do
    before do
      Person.delete_all
      Prescription.delete_all
    end

    {
      "both saved" => lambda{ @person = Person.create; @prescription = Prescription.create},
      "Prescription not saved" => lambda{ @person = Person.create; @prescription = Prescription.new},
      # "both not saved" => lambda{ @person = Person.new; @prescription = Prescription.new},
    }.each do |precondition_name, precondition_lambda|
      context(precondition_name) do
        before(&precondition_lambda)

        {
          "when Prescription#person_id= is used" => lambda{@prescription.person_id = @person.id; @prescription.save!},
          "when Prescription#person= is used"    => lambda{@prescription.person = @person; @prescription.save!},
          "when Person#prescriptions= is used"    => lambda{@person.prescriptions = [@prescription]; @prescription.save!},
          "when Person#prescriptions << is used"    => lambda{@person.prescriptions << @prescription; @prescription.save!},
        }.each do |context_desc, before_lambda|
          context(context_desc) do
            before(&before_lambda)

            it "Prescription#person_id " do
              @prescription.person_id.should == @person.id
            end
            it "リロードしてもOK" do
              prescription = Prescription.find(@prescription.id)
              prescription.person_id.should == @person.id
            end
            it "Person#prescriptionsでも取得できるべき" do
              person = Person.find(@person.id)
              person.prescriptions.map(&:id).should == [@prescription.id]
            end
            it "@personは保存されている" do
              @person.id.should_not be_nil
            end
            it "@prescriptionは保存されている" do
              @prescription.id.should_not be_nil
            end
          end
        end

      end
    end
  end


  describe "Preference#person", "Person#preferences" do
    before do
      Person.delete_all
      Preference.delete_all
    end

    {
      "both saved" => lambda{ @person = Person.create; @preference = Preference.create},
      "Preference not saved" => lambda{ @person = Person.create; @preference = Preference.new},
      # "both not saved" => lambda{ @person = Person.new; @preference = Preference.new},
    }.each do |precondition_name, precondition_lambda|
      context(precondition_name) do
        before(&precondition_lambda)

        {
          # "when Preference#person_ids= is used" => lambda{@preference.person_ids = [@person.id]; @preference.save!},
          # "when Preference#person_ids << is used" => lambda{@preference.person_ids << @person.id; @preference.save!},
          "when Preference#people = is used"    => lambda{@preference.people = [@person]; @preference.save!},
          "when Preference#people << is used"    => lambda{@preference.people << @person; @preference.save!},
          # "when Person#preference_ids= is used"    => lambda{@person.preference_ids = [@preference.id]; @preference.save!},
          # "when Person#preference_ids << is used"    => lambda{@person.preference_ids << @preference.id; @preference.save!},
          "when Person#preferences= is used"    => lambda{@person.preferences = [@preference]; },
          "when Person#preferences << is used"    => lambda{@person.preferences << @preference; },
        }.each do |context_desc, before_lambda|
          context(context_desc) do
            before(&before_lambda)

            it "Preference#person_ids " do
              @preference.person_ids.should == [@person.id]
            end
            it "Person#preference_ids " do
              @person.preference_ids.should == [@preference.id]
            end
            it "リロードしてもOK" do
              preference = Preference.find(@preference.id)
              preference.person_ids.should == [@person.id]
            end
            it "Preference#peopleでも取得できるべき" do
              preference = Preference.find(@preference.id)
              preference.people.map(&:id).should == [@person.id]
            end
            it "Person#preferencesでも取得できるべき" do
              person = Person.find(@person.id)
              person.preferences.map(&:id).should == [@preference.id]
            end
            it "@personは保存されている" do
              @person.id.should_not be_nil
            end
            it "@preferenceは保存されている" do
              @preference.id.should_not be_nil
            end
          end
        end

      end
    end
  end


end
