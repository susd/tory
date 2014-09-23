app = 'tory'
bind "unix:///tmp/#{app}_puma.sock"
pidfile "/srv/rails/#{app}/current/tmp/pids/puma"
state_path "/srv/rails/#{app}/current/tmp/puma_state"
environment 'production'
activate_control_app