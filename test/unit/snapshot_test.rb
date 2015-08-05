require 'test_helper'

class SnapshotTest < ActiveSupport::TestCase

  fixtures :investigations
  
  setup do
    @investigation = Factory(:investigation, :policy => Factory(:publicly_viewable_policy))
  end

  test 'snapshot number correctly set' do
    s1 = @investigation.create_snapshot
    s2 = @investigation.create_snapshot

    assert_equal 1, s1.snapshot_number
    assert_equal 2, s2.snapshot_number
  end

  test 'can access snapshot metadata' do
    snapshot = @investigation.create_snapshot

    assert snapshot.metadata.is_a?(Hash)
    assert_equal @investigation.title, snapshot.metadata['title']
  end

  test 'can fetch by snapshot number' do
    s1 = @investigation.create_snapshot
    s2 = @investigation.create_snapshot
    s3 = @investigation.create_snapshot

    assert_equal 3, @investigation.snapshots.count
    assert_equal s2, @investigation.snapshot(2)
    assert_equal s3, @investigation.snapshot(3)
    assert_equal s1, @investigation.snapshot(1)
  end

  test 'snapshot captures state' do
    old_title = @investigation.title
    old_description = @investigation.description
    snapshot = @investigation.create_snapshot

    @investigation.update_attributes(title: "New title", description: "New description")

    assert_equal "New title", @investigation.title
    assert_equal "New description", @investigation.description
    assert_equal old_title, snapshot.title
    assert_equal old_description, snapshot.description
  end

  test 'generates sensible DOI' do
    snapshot = @investigation.create_snapshot

    assert_equal "#{Seek::Config.doi_prefix}/#{Seek::Config.doi_suffix}.investigation.#{@investigation.id}.#{snapshot.snapshot_number}", snapshot.suggested_doi
  end

  test 'generates valid DataCite metadata' do
    snapshot = @investigation.create_snapshot

    assert snapshot.datacite_metadata.validate
  end

  test 'creates DOI via datacite' do
    datacite_mock

    snapshot = @investigation.create_snapshot

    res = snapshot.mint_doi
    assert res
    assert_equal snapshot.suggested_doi, snapshot.doi
    assert_empty snapshot.errors
  end


  test "doesn't create DOI if already minted" do
    datacite_mock

    snapshot = @investigation.create_snapshot
    snapshot.doi = '123'

    res = snapshot.mint_doi
    assert !res
    assert_equal '123', snapshot.doi
    assert_not_empty snapshot.errors
  end

  private

  def datacite_mock
    stub_request(:post, "https://test:test@test.datacite.org/mds/metadata").to_return(:body => 'OK (10.5072/my_test)', :status => 201)
    stub_request(:post, "https://test:test@test.datacite.org/mds/doi").to_return(:body => 'OK', :status => 201)
  end

end