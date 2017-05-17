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

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'java_buildpack/util/qualify_path'


module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch AppDynamics support.
    class TakipiAgent < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        uri = @configuration['uri']
        version = @configuration['version']
        download_tar(version, uri)
        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        java_opts   = @droplet.java_opts
        java_opts.add_agentlib('TakipiAgent')
        application_name java_opts
        set_environment_variables
      end

      def detect
        @configuration['secret_key'] != 'REPLACE_ME' ? "takipi-agent=#{@configuration['version']}" : nil
      end

      private
      def jvm_lib_file
        @droplet.java_home.root + 'lib/amd64/server/libjvm.so'
      end

      def set_environment_variables
        env = @droplet.environment_variables
        sandbox = @droplet.sandbox
        # find a way to avoid LD_LIBRARY_PATH
        env.add_environment_variable('LD_LIBRARY_PATH', "$LD_LIBRARY_PATH:#{qualify_path(sandbox + 'lib', @droplet.root)}")
        env.add_environment_variable('JVM_LIB_FILE', jvm_lib_file)
        env.add_environment_variable('TAKIPI_HOME', sandbox)
        env.add_environment_variable('TAKIPI_SECRET_KEY', "'#{@configuration['secret_key']}'")
        env.add_environment_variable('TAKIPI_MACHINE_NAME', node_name)
      end

      def application_name(java_opts)
        app_name = @configuration['application_name'] || @application.details['application_name']
        java_opts.add_system_property('takipi.name', app_name)
      end

      def node_name
        if @configuration['node_name_prefix'] && !@configuration['node_name_prefix'].empty?
          "#{@configuration['node_name_prefix']}-$CF_INSTANCE_INDEX"
        else
          %q|$(ruby -rjson -e "puts JSON.parse(ENV['VCAP_APPLICATION'])['instance_id']")|
        end
      end
    end

  end
end
