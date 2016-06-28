# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2016 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'component_helper'
require 'java_buildpack/framework/takipi_agent'

describe JavaBuildpack::Framework::TakipiAgent do
  include_context 'component_helper'

  context do
    let(:configuration) do
      {
        'uri' => 'test-uri',
        'secret_key' => 'test-secret'
      }
    end

    it 'expands Takipi agent tarball',
       cache_fixture: 'stub-takipi-agent.tar.gz' do

      component.compile

      expect(sandbox + 'lib/libTakipiAgent.so').to exist
    end

    it 'symlinks the log directory',
     cache_fixture: 'stub-takipi-agent.tar.gz' do

      component.compile
      expect(sandbox + 'log').to be_symlink
    end

    it 'updates JAVA_OPTS' do
      component.release
      expect(java_opts).to include('-agentlib:TakipiAgent')
      expect(java_opts).to include('-Dtakipi.name=test-application-name')
    end

    it 'updates environment varilables' do
      component.release

      expect(environment_variables).to include("TAKIPI_SECRET_KEY='test-secret'")
      expect(environment_variables).to include("LD_LIBRARY_PATH=$PWD/.java-buildpack/takipi_agent/lib")
      expect(environment_variables).to include("JVM_LIB_FILE=$PWD/.test-java-home/lib/amd64/server/libjvm.so")
      expect(environment_variables).to include("TAKIPI_HOME=$PWD/.java-buildpack/takipi_agent")
      expect(environment_variables).to include("PATH=$PATH:$PWD/.java-buildpack/takipi_agent/bin")
    end

    context 'configuration overrides' do

      let(:configuration) do
        { 'node_name_prefix' => "test-name",
          'application_name' => "test-name" }
      end

      it 'updates JAVA_OPTS' do
        component.release
        expect(java_opts).to include('-agentlib:TakipiAgent')
        expect(java_opts).to include('-Dtakipi.name=test-name')
      end

    end
  end

end
