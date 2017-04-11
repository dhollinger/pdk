require 'spec_helper'

describe PDK::Generate::Module do
  context 'when gathering module information via the user interview' do
    let (:metadata) { PDK::Module::Metadata.new.update(
                        'name' => 'foo-bar',
                        'version' => '0.1.0',
                        'dependencies' => [
                          { 'name' => 'puppetlabs-stdlib', 'version_requirement' => '>= 1.0.0' }
                        ]
                      )
                    }

    it 'should populate the Metadata object based on user input' do
      allow(STDOUT).to receive(:puts)
      expect(PDK::CLI::Input).to receive(:get) { '2.2.0' }
      expect(PDK::CLI::Input).to receive(:get) { 'William Hopper' }
      expect(PDK::CLI::Input).to receive(:get) { 'Apache-2.0' }
      expect(PDK::CLI::Input).to receive(:get) { 'A simple module to do some stuff.' }
      expect(PDK::CLI::Input).to receive(:get) { 'github.com/whopper/bar' }
      expect(PDK::CLI::Input).to receive(:get) { 'forge.puppet.com/whopper/bar' }
      expect(PDK::CLI::Input).to receive(:get) { 'tickets.foo.com/whopper/bar' }
      expect(PDK::CLI::Input).to receive(:get) { 'yes' }

      described_class.module_interview(metadata)

      expect(metadata.data).to eq(
        {
          'name'          => 'foo-bar',
          'version'       => '2.2.0',
          'author'        => 'William Hopper',
          'license'       => 'Apache-2.0',
          'summary'       => 'A simple module to do some stuff.',
          'source'        => 'github.com/whopper/bar',
          'project_page'  => 'forge.puppet.com/whopper/bar',
          'issues_url'    => 'tickets.foo.com/whopper/bar',
          'dependencies'  => [{'name' => 'puppetlabs-stdlib', 'version_requirement' => '>= 1.0.0'}],
          'data_provider' => nil,
        }
      )
    end
  end
end
