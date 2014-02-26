app = 'tory'
bind "unix:///tmp/#{app}_puma.sock"
pidfile "/srv/rails/#{app}/current/tmp/puma/pid"
state_path "/srv/rails/#{app}/current/tmp/puma/state"
environment 'production'
activate_control_app