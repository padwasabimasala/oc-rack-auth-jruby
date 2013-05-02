require 'spec_helper'

def mock_env
  {
    'rack.session' => {},
    'rack.input' => StringIO.new('test=true')
  }
end


describe Rack::Auth::OCTanner do

  let(:app){ lambda { |env| [200, {}, []] } }
  let(:options){ { client_id: '1', client_secret: 'secret' } }
  let(:middleware){ Rack::Auth::OCTanner.new app, options }

  let(:token_string){ '1234567890' }
  let(:user_info){ { 'user_id' => '1', 'company_id' => '2', 'application_id' => '3', 'scopes' => [ 'foo' ] } }

  let(:user_info_url){ 'https://api.octanner.com/api/userinfo' }
  let(:user_info_ok){ { status: 200, body: user_info.to_json } }
  let(:user_info_unauthorized){ { status: 401 } }


  subject{ middleware }


  describe '#initialize' do

    it 'assigns the app variable' do
      subject.instance_variable_get( :@app ).should eq app
    end

    it 'assigns the options variable' do
      subject.instance_variable_get( :@options ).should eq options
    end

  end


  describe '#call' do

    it 'should set env objects if authentication succeeds' do
      stub_request(:any, user_info_url).to_return(user_info_ok)
      env = mock_env
      subject.call(env)
      env['oauth2_token_data'].should eq user_info
      env['oauth2_token'].should be_kind_of OAuth2::AccessToken
    end

    it 'should set nil env objects if authentication fails' do
      stub_request(:any, user_info_url).to_return(user_info_unauthorized)
      env = mock_env
      subject.call(env)
      env['oauth2_token_data'].should be_nil
      env['oauth2_token'].should be_nil
    end

  end



  describe '#validate_token' do

    before :each do
      @request = OpenStruct.new
      @request.params = {}
      @request.env = {}
    end

    it 'should validate and return a valid user response' do
      token = double('token', get: double('response', body: user_info.to_json))
      subject.validate_token(token).should eq user_info
    end
  end


  describe '#token_from_request' do

    before :each do
      @request = OpenStruct.new
      @request.params = {}
      @request.env = {}
    end

    it 'returns an OAuth2::AccessToken object' do
      subject.token_from_request(@request).should be_kind_of OAuth2::AccessToken
    end

  end


  describe '#token_string_from_request' do

    before :each do
      @request = OpenStruct.new
      @request.params = {}
      @request.env = {}
    end

    it 'returns nil if no request' do
      subject.token_string_from_request(nil).should be_nil
    end

    context 'with request params' do
      it 'matches bearer_token' do
        @request.params['bearer_token'] = token_string
        subject.token_string_from_request(@request).should eq token_string
      end

      it 'matches access_token' do
        @request.params['access_token'] = token_string
        subject.token_string_from_request(@request).should eq token_string
      end

      it 'matches oauth_token' do
        @request.params['oauth_token'] = token_string
        subject.token_string_from_request(@request).should eq token_string
      end
    end

    context 'with HTTP_AUTHORIZATION header' do
      it 'matches Bearer' do
        @request.env['HTTP_AUTHORIZATION'] = "Bearer token=#{token_string}"
        subject.token_string_from_request(@request).should eq token_string
      end

      it 'matches OAuth' do
        @request.env['HTTP_AUTHORIZATION'] = "OAuth token=#{token_string}"
        subject.token_string_from_request(@request).should eq token_string
      end

      it 'matches Token' do
        @request.env['HTTP_AUTHORIZATION'] = "Token token=#{token_string}"
        subject.token_string_from_request(@request).should eq token_string
      end
    end
  end

end