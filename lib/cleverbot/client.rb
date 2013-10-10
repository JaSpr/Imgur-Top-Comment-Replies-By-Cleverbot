# Copyright (c) 2011 Benjamin Manns
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative 'parser'

module Cleverbot
  # Ruby wrapper for Cleverbot.com.
  class Client
    include HTTParty

    # The default form variables for POSTing to Cleverbot.com
    DEFAULT_PARAMS = {
      'stimulus' => '',
      'start' => 'y',
      'sessionid' => '',
      'vText8' => '',
      'vText7' => '',
      'vText6' => '',
      'vText5' => '',
      'vText4' => '',
      'vText3' => '',
      'vText2' => '',
      'icognoid' => 'wsf',
      'icognocheck' => '',
      'fno' => '0',
      'prevref' => '',
      'emotionaloutput' => '',
      'emotionalhistory' => '',
      'asbotname' => '',
      'ttsvoice' => '',
      'typing' => '',
      'lineref' => '',
      'sub' => 'Say',
      'islearning' => '1',
      'cleanslate' => 'false',
    }

    # The path to the form endpoint on Cleverbot.com.
    PATH = '/webservicemin'

    base_uri 'http://www.cleverbot.com'

    parser Parser
    headers 'Accept-Encoding' => 'gzip'

    # Holds the parameters for an instantiated Client.
    attr_reader :params

    # Creates a digest from the form parameters.
    #
    # ==== Parameters
    #
    # [<tt>body</tt>] <tt>String</tt> to be digested.
    def self.digest body
      Digest::MD5.hexdigest body[9...35]
    end

    # Sends a message to Cleverbot.com and returns a <tt>Hash</tt> containing the parameters received.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    # [<tt>params</tt>] Optional <tt>Hash</tt> with form parameters. Merged with DEFAULT_PARAMS. Defaults to <tt>{}</tt>.
    def self.write message='', params={}
      body = DEFAULT_PARAMS.merge params
      body['stimulus'] = message
      body['icognocheck'] = digest HashConversions.to_params(body)

      post(PATH, :body => body).parsed_response
    end

    # Initializes a Client with given parameters.
    #
    # ==== Parameters
    #
    # [<tt>params</tt>] Optional <tt>Hash</tt> holding the initial parameters. Defaults to <tt>{}</tt>.
    def initialize params={}
      @params = params
    end

    # Sends a message and returns a <tt>String</tt> with the message received. Updates #params to maintain state.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    def write message=''
      response = self.class.write message, @params
      message = response['message']
      response.keep_if { |key, value| DEFAULT_PARAMS.keys.include? key }
      @params.merge! response
      @params.delete_if { |key, value| DEFAULT_PARAMS[key] == value }
      message
    end
  end
end