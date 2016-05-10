JobClass.define('exec') {
  parameters {|params|
    params.add StringListParam.new('args', 'ARG', 'Command line arguments.')
  }

  script {|params, script|
    script.task(params.generic_ds) {|task|
      task.action(params['args'].join(' ')) {|ds|
        ds.logger.info '[CMD] ' + params['args'].join(' ')
        except_bundler_env = Hash[%w(BUNDLE_BIN_PATH BUNDLE_GEMFILE GEM_HOME GEM_PATH RUBYLIB RUBYOPT).map {|k| [k, nil] }]
        system(except_bundler_env, *params['args'])
        st = $?
        ds.logger.info "status=#{st.exitstatus}"
        JobResult.for_bool(st.exitstatus == 0)
      }
    }
  }
}
