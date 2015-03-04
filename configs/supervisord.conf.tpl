[supervisord]
nodaemon  = true
user      = root
loglevel  = {{ default .Env.SUPERVISOR_LOG_LEVEL "INFO" }}

[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[program:couchpotato]
command = python CouchPotato.py --data_dir {{ default .Env.CP_DATA_DIR "/data" }} --config_file {{ default .Env.CP_CONFIG "/data/settings.conf" }} --console_log
directory               = {{ default .Env.COUCHPOTATO_HOME "/couchpotato" }}
user                    = root
autostart               = true
autorestart             = unexpected
stopsignal              = TERM
stopasgroup             = true
stopwaitsecs            = 10
stdout_logfile          = /dev/stderr
stdout_logfile_maxbytes = 0
stderr_logfile          = /dev/stderr
stderr_logfile_maxbytes = 0

[program:updater]
command                 = python -u /usr/local/bin/updater.py -a couchpotato -b {{ default .Env.COUCHPOTATO_CHANNEL "master" }} -f {{ default .Env.UPDATE_FREQUENCY }}
stdout_logfile          = /dev/stderr
stdout_logfile_maxbytes = 0
stderr_logfile          = /dev/stderr
stderr_logfile_maxbytes = 0