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

    it 'assigns zero-based ordinals to the scopes in the map' do
      scopes = Rack::Auth::Scopes.new scope_string
      scope_map = scopes.instance_variable_get(:@scopes)
      ordinal = 0
      scope_string.split(',').map(&:strip).each do |scope|
        scope_map[scope].should eq ordinal
        ordinal = ordinal + 1
      end
    end
  end

end
