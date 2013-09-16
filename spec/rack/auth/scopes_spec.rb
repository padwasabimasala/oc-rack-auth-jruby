require 'spec_helper'

describe Rack::Auth::Scopes do

  let(:scope_string){ "public, user.read, user.write, user.delete, admin.read, admin.write, admin.delete" }

  describe '#initialize' do
    it 'defaults to no scopes' do
      scopes = Rack::Auth::Scopes.new
      scopes.instance_variable_get(:@scopes).should be_empty
    end

    it 'assigns scopes into the map' do
      scopes = Rack::Auth::Scopes.new scope_string
      scope_map = scopes.instance_variable_get(:@scopes)
      scope_map.keys.join(', ').should eq scope_string
    end
  end

end
