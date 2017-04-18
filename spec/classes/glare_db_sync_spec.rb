require 'spec_helper'

describe 'glare::db::sync' do

  shared_examples_for 'glare-dbsync' do

    it 'runs glare-manage db_sync' do
      is_expected.to contain_exec('glare-db-sync').with(
        :command     => 'glare-db-manage  upgrade',
        :user        => 'glare',
        :path        => ["/bin/","/usr/bin/" ,"/usr/local/bin"],
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[glare::install::end]',
                         'Anchor[glare::config::end]',
                         'Anchor[glare::dbsync::begin]'],
        :notify      => 'Anchor[glare::dbsync::end]',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/glare/glare.conf',
        }
      end

      it {
        is_expected.to contain_exec('glare-db-sync').with(
          :command     => 'glare-db-manage --config-file /etc/glare/glare.conf upgrade',
          :user        => 'glare',
          :path        => ["/bin/","/usr/bin/" ,"/usr/local/bin"],
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[glare::install::end]',
                           'Anchor[glare::config::end]',
                           'Anchor[glare::dbsync::begin]'],
          :notify      => 'Anchor[glare::dbsync::end]',
        )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'glare-dbsync'
    end
  end

end
