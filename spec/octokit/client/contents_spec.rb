# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Contents do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".readme" do

    it "returns the default readme" do
      stub_get("/repos/sferik/rails_admin/readme").
        to_return(:body => fixture("v3/readme.json"))
      readme = @client.readme('sferik/rails_admin')
      expect(readme.encoding).to eq("base64")
      expect(readme.type).to eq("file")
    end

  end

  describe ".contents" do

    it "returns the contents of a file" do
      stub_get("/repos/sferik/rails_admin/contents/lib/octokit.rb").
        to_return(:body => fixture("v3/contents.json"))
      contents = @client.contents('sferik/rails_admin', :path => "lib/octokit.rb")
      expect(contents.path).to eq("lib/octokit.rb")
      expect(contents.name).to eq("lib/octokit.rb")
      expect(contents.encoding).to eq("base64")
      expect(contents.type).to eq("file")
    end

  end

  describe ".archive_link" do

    it "returns the headers of the request" do
      stub_get("/repos/sferik/rails_admin/tarball/master").
        to_return(:status => 302, :body => '', :headers =>
          { 'location' => "https://nodeload.github.com/repos/sferik/rails_admin/tarball/"})
      archive_link = @client.archive_link('sferik/rails_admin', :ref => "master")
      expect(archive_link).to eq("https://nodeload.github.com/repos/sferik/rails_admin/tarball/")
    end

  end

end
