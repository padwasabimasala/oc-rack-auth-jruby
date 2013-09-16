require 'spec_helper'

describe Rack::Auth::Scopes do

  let(:scope_string){ "public, user.read, user.write, user.delete, admin.read, admin.write, admin.delete" }
  let(:scopes){ Rack::Auth::Scopes.new scope_string }

  subject{ scopes }

  describe '#initialize' do
    it 'defaults to no scopes' do
      scopes = Rack::Auth::Scopes.new
      scopes.instance_variable_get(:@scope_map).should be_empty
      scopes.instance_variable_get(:@scope_array).should be_empty
    end

    it 'assigns scopes into the map' do
      scopes = Rack::Auth::Scopes.new scope_string
      scope_map = scopes.instance_variable_get(:@scope_map)
      scope_map.keys.join(', ').should eq scope_string
    end

    it 'assigns zero-based ordinals to the scopes in the map' do
      scopes = Rack::Auth::Scopes.new scope_string
      scope_map = scopes.instance_variable_get(:@scope_map)
      ordinal = 0
      scope_string.split(',').map(&:strip).each do |scope|
        scope_map[scope].should eq ordinal
        ordinal = ordinal + 1
      end
    end

    it 'assigns scopes into the ordinal array' do
      scopes = Rack::Auth::Scopes.new scope_string
      scope_array = scopes.instance_variable_get(:@scope_array)
      scope_array.join(', ').should eq scope_string
    end
  end

  describe '#has_scope?' do
    it 'returns true if the scope is included' do
      subject.has_scope?('public').should be_true
    end

    it 'returns false if the scope is not included' do
      subject.has_scope?('private').should be_false
    end

    # it 'returns false if the scopes are empty' do
    #   Rack::Auth::Scopes.new.has_scope?('public').should be_true
    # end

    it 'returns false if the given scope is empty' do
      subject.has_scope?('').should be_false
    end

    it 'returns false if the given scope is nil' do
      subject.has_scope?(nil).should be_false
    end
  end

  describe '#has_scopes?' do
    it 'returns true if all the given scopes are included' do
      subject.has_scopes?(%w(public user.read user.write)).should be_true
    end

    it 'returns false if at least one given scope is not included' do
      subject.has_scopes?(%w(public, private, user.write)).should be_false
    end

    it 'returns false if the scopes are empty' do
      Rack::Auth::Scopes.new.has_scopes?(%w(public, user.read, user.write)).should be_false
    end

    it 'returns false if the given scopes are empty' do
      subject.has_scopes?([]).should be_false
    end

    it 'returns false if the given scopes are nil' do
      subject.has_scopes?(nil).should be_false
    end
  end

end
