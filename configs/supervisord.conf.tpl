[supervisord]
nodaemon  = true
user      = root
loglevel  = {{ default .Env.SUPERVISOR_LOG_LEVEL "INFO" }}

[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[program:couchpotato]
command = python CouchPotato.py --data_dir {{ default .Env.CP_DATA_DIR "/data" }} --config_file {{ default .Env.CP_CONFIG "/data/settings.conf" }} --console_log
directory               = /couchpotato
user                    = root
autostart               = true
autorestart             = unexpected
stopsignal              = TERM
stopasgroup             = true
stopwaitsecs            = 10
stdout_logfile          = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile          = /dev/stderr
stderr_logfile_maxbytes = 0

[program:dnsmasq]
command                 = dnsmasq -kd
stdout_logfile          = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile          = /dev/stderr
stderr_logfile_maxbytes = 0