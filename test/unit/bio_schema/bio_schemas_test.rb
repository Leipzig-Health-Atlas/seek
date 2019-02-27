require 'test_helper'

class BioSchemaTest < ActiveSupport::TestCase

  test 'supported?' do
    p = Factory(:person)
    not_supported = unsupported_type

    assert Seek::BioSchema::BioSchema.supported?(p)
    refute Seek::BioSchema::BioSchema.supported?(not_supported)
  end

  test 'exception for unsupported type' do
    o = unsupported_type
    assert_raise Seek::BioSchema::UnsupportedTypeException do
      Seek::BioSchema::BioSchema.new(o).json_ld
    end
  end

  test 'person wrapper test' do
    p = Factory(:person, first_name: 'Bob', last_name: 'Monkhouse', description: 'I am a person', avatar: Factory(:avatar))
    refute_nil p.avatar
    wrapper = Seek::BioSchema::ResourceWrappers::Person.new(p)
    assert_equal p.id, wrapper.id
    assert_equal p.title, wrapper.title
    assert_equal p.first_name, wrapper.first_name
    assert_equal p.last_name, wrapper.last_name
    assert_equal p.description, wrapper.description
    assert_equal "http://localhost:3000/people/#{p.id}/avatars/#{p.avatar.id}?size=250", wrapper.image
  end

  test 'person json_ld' do
    p = Factory(:person, first_name: 'Bob', last_name: 'Monkhouse',
                description: 'I am a person', avatar: Factory(:avatar),
                web_page:'http://me.com')
    refute_nil p.avatar
    json = Seek::BioSchema::BioSchema.new(p).json_ld
    json = JSON.parse(json)
    pp json
    assert_equal "http://localhost:3000/people/#{p.id}", json['@id']
    assert_equal 'Bob Monkhouse', json['name']
    assert_equal 'Person', json['@type']
    assert_equal 'I am a person', json['description']
    assert_equal 'Bob', json['givenName']
    assert_equal 'Monkhouse', json['familyName']
    assert_equal 'http://me.com',json['url']
    refute_nil json['image']
    refute_nil json['@context']
  end

  test 'project json ld' do
    project = Factory(:project, title:'my project',description:'i am a project', avatar:Factory(:avatar), web_page:'http://project.com')
    refute_nil project.avatar
    json = Seek::BioSchema::BioSchema.new(project).json_ld
    json = JSON.parse(json)
    pp json

    assert_equal "http://localhost:3000/projects/#{project.id}", json['@id']
    assert_equal 'my project', json['name']
    assert_equal 'Project', json['@type']
    assert_equal 'i am a project', json['description']
    assert_equal "http://localhost:3000/projects/#{project.id}/avatars/#{project.avatar.id}?size=250",json['logo']
    assert_equal 'http://project.com',json['url']

    #project with no webpage, just to check the default url
    project = Factory(:project)
    json = Seek::BioSchema::BioSchema.new(project).json_ld
    json = JSON.parse(json)
    assert_equal "http://localhost:3000/projects/#{project.id}",json['url']

  end

  test 'resource wrapper factory' do

    wrapper = Seek::BioSchema::ResourceWrappers::Factory.instance.get(Factory(:person))
    assert wrapper.is_a?(Seek::BioSchema::ResourceWrappers::Person)

    assert_raise Seek::BioSchema::UnsupportedTypeException do
      Seek::BioSchema::ResourceWrappers::Factory.instance.get(unsupported_type)
    end

  end

  private

  # an instance of a model that doesn't support bio_schema / schema
  def unsupported_type
    Factory(:investigation)
  end
end
