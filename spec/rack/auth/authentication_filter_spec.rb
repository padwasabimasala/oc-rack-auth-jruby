require 'spec_helper'

describe Rack::Auth::AuthenticationFilter do

  let(:user_info){ { 'person_id' => '1', 'company_id' => '2', 'scopes' => [ 'foo' ] } }

  let(:response_ok){ { status: 200, body: user_info.to_json } }
  let(:response_unauthorized){ { status: 401 } }

  describe '#initialize' do

    it 'defaults to no scopes' do
      subject.instance_variable_get(:@required_scopes).should be_empty
    end

    it 'accepts an array of scopes' do
      scopes = [ :one, :two, :three ]
      filter = Rack::Auth::AuthenticationFilter.new scopes
      filter.instance_variable_get(:@required_scopes).should eq Set.new scopes
    end
  end


  describe '#before' do

    it 'calls controller.head(401) when authentication fails' do
      controller = double('controller', request: nil)
      controller.should_receive(:head).with(401)
      subject.before(controller)
    end
  end


  describe '#authenticate_request' do

    before :each do
      @request = OpenStruct.new
      @request.params = {}
      @request.env = {}
    end

    it 'should return true if authentication succeeds' do
      @request.env['oauth2_token_data'] = user_info
      subject.authenticate_request(@request).should be true
    end

    it 'should return true if authentication succeeds with scopes' do
      filter = Rack::Auth::AuthenticationFilter.new [ :foo ]
      @request.env['oauth2_token_data'] = user_info
      filter.authenticate_request(@request).should be true
    end

    context 'authentication failures' do

      it 'should return false if no request' do
        subject.authenticate_request(nil).should be false
      end

      it 'should return false if no user data' do
        subject.authenticate_request(@request).should be false
      end

      it 'should return false if user data is missing required scopes' do
        filter = Rack::Auth::AuthenticationFilter.new [ :foo, :bar ]
        @request.env['oauth2_token_data'] = user_info
        filter.authenticate_request(@request).should be false
      end
    end

  end


  describe '#authenticate_scopes' do

    it 'returns true if no required scopes' do
      subject.authenticate_scopes([ :foo, :bar ]).should eq true
    end

    it 'returns true if all required scopes included' do
      filter = Rack::Auth::AuthenticationFilter.new [ :foo, :bar ]
      filter.authenticate_scopes([ :foo, :bar ]).should eq true
    end

    it 'returns true if all required scopes included using strings' do
      filter = Rack::Auth::AuthenticationFilter.new [ :foo, :bar ]
      filter.authenticate_scopes([ 'foo', 'bar' ]).should eq true
    end

    it 'returns false if required scope not included' do
      filter = Rack::Auth::AuthenticationFilter.new [ :foo, :bar ]
      filter.authenticate_scopes([ :foo ]).should eq false
    end
  end
end