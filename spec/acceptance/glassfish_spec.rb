require 'spec_helper_acceptance'

describe 'glassfish class' do

  case fact('osfamily')
  when 'RedHat'
    jdk_package = 'java-1.7.0-openjdk-devel'
  else 
    jdk_package = 'openjdk-7-jdk'
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'glassfish': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    # Java 7 OpenJDK should be installed 
    describe package(jdk_package) do
      it { should be_installed }
    end

    # Group and user should exist
    describe group('glassfish') do
      it { should exist }
    end

    describe user('glassfish') do
      it { should exist }
    end

    # Glassfish should be installed
    describe file('/usr/local/glassfish-3.1.2.2') do
      it { should be_directory }
      it { should be_owned_by 'glassfish' }
      it { should be_grouped_into 'glassfish' }
    end

    describe file('/usr/local/glassfish-3.1.2.2/domains/domain1') do
      it { should_not be_directory }
    end

    # Profile file should be present
    describe file('/etc/profile.d/glassfish.sh') do
      it { should be_file }
    end

    #describe package('') do
    #  it { should be_installed }
    #end

    #describe service('glassfish') do
    #  it { should be_enabled }
    #  it { should be_running }
    #end
  end
end

