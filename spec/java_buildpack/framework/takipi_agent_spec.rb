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
      { 'uri' => 'test-uri' }
    end

    it 'expands Takipi agent tarball',
       cache_fixture: 'stub-takipi-agent.tar.gz' do

      component.compile

      expect(sandbox + 'lib/libTakipiAgent.so').to exist
    end

    it 'updates JAVA_OPTS' do
      component.release
      expect(java_opts).to include('-agentpath:$PWD/.java-buildpack/takipi_agent/lib/libTakipiAgent.so')
      expect(java_opts).to include('-Dtakipi.name=test-application-name')
    end

    context 'configuration overrides' do

      let(:configuration) do
        { 'node_name_prefix' => "test-name",
          'application_name' => "test-name" }
      end

      it 'updates JAVA_OPTS' do
        component.release
        expect(java_opts).to include('-agentpath:$PWD/.java-buildpack/takipi_agent/lib/libTakipiAgent.so')
        expect(java_opts).to include('-Dtakipi.name=test-name')
      end

    end
  end

end
