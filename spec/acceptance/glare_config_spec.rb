require 'spec_helper_acceptance'

describe 'basic glare config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Glare_config <||>
      File <||> -> Glare_paste_ini <||>

      file { '/etc/glare' :
        ensure => directory,
      }
      file { '/etc/glare/glare.conf' :
        ensure => file,
      }
      file { '/etc/glare/glare-paste.ini' :
        ensure => file,
      }

      glare_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }
      glare_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }
      glare_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }
      glare_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      glare_paste_ini { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }
      glare_paste_ini { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }
      glare_paste_ini { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }
      glare_paste_ini { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

     EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/glare/glare.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/glare/glare-paste.ini') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.not_to match /thisshouldnotexist/ }
      end
    end
  end
end
