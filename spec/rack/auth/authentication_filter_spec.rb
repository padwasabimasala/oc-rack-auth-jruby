require 'spec_helper'

describe Rack::Auth::AuthenticationFilter do

  let(:scope_1){ 1 }
  let(:scope_2){ 2 }
  let(:scope_3){ 4 }

  let(:token_info) {
    {
      'u' => 'user-id',
      's' => (scope_1 + scope_2),
      'c' => 'client-id',
      'e' => 383
    }
  }


  let(:response_ok){ { status: 200, body: token_info.to_json } }
  let(:response_unauthorized){ { status: 401 } }

  describe '#initialize' do
    it 'defaults to no scopes' do
      subject.instance_variable_get(:@required_scopes).should eq 0
    end

    it 'accepts nil for no scopes' do
      filter = Rack::Auth::AuthenticationFilter.new nil
      filter.instance_variable_get(:@required_scopes).should eq 0
    end

    it 'accepts a single scope value' do
      filter = Rack::Auth::AuthenticationFilter.new scope_1
      filter.instance_variable_get(:@required_scopes).should eq scope_1
    end

    it 'accepts an array of scope values' do
      scopes = [ scope_1, scope_2, scope_3 ]
      filter = Rack::Auth::AuthenticationFilter.new scopes
      filter.instance_variable_get(:@required_scopes).should eq (scope_1 + scope_2 + scope_3)
    end

    it 'accepts an empty array' do
      filter = Rack::Auth::AuthenticationFilter.new []
      filter.instance_variable_get(:@required_scopes).should eq 0
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
      filter = Rack::Auth::AuthenticationFilter.new
      Rack::Auth::AuthenticationFilter.any_instance.stub(:authenticate_scopes).and_return(true)
      Rack::Auth::AuthenticationFilter.any_instance.stub(:authenticate_expires).and_return(true)
      @request.env['octanner_auth_user'] = token_info
      subject.authenticate_request(@request).should be true
    end

    it 'tries to authenticate scopes' do
      filter = Rack::Auth::AuthenticationFilter.new
      filter.should_receive(:authenticate_scopes).once
      Rack::Auth::AuthenticationFilter.any_instance.stub(:authenticate_expires).and_return(true)
      @request.env['octanner_auth_user'] = token_info
      filter.authenticate_request(@request)
    end

    it 'tries to authenticate expiration' do
      filter = Rack::Auth::AuthenticationFilter.new
      Rack::Auth::AuthenticationFilter.any_instance.stub(:authenticate_scopes).and_return(true)
      filter.should_receive(:authenticate_expires).once
      @request.env['octanner_auth_user'] = token_info
      filter.authenticate_request(@request)
    end

    context 'authentication failures' do
      it 'should return false if no request' do
        subject.authenticate_request(nil).should be false
      end

      it 'should return false if no token data' do
        subject.authenticate_request(@request).should be false
      end
    end
  end


  describe '#authenticate_scopes' do
    it 'returns true if no scopes are required' do
      subject.authenticate_scopes([ scope_1, scope_2 ]).should eq true
    end

    it 'returns true if all required scopes are included' do
      filter = Rack::Auth::AuthenticationFilter.new [ scope_1, scope_2 ]
      filter.authenticate_scopes([ scope_1, scope_2 ]).should eq true
    end

    it 'returns false if only some required scopes are included' do
      filter = Rack::Auth::AuthenticationFilter.new [ scope_1, scope_2 ]
      filter.authenticate_scopes(scope_1).should eq false
    end
  end


  describe "#authenticate_expires" do
    let(:token_smd){ 383 }
    let(:token_time){ Rack::Auth::SmD.new.date token_smd}

    it "returns true if token has not expired" do
      subject.authenticate_expires(token_smd, token_time - 1).should eq true
    end

    it "returns false if token has expired" do
      subject.authenticate_expires(token_smd, token_time + 1).should eq false
    end
  end
end