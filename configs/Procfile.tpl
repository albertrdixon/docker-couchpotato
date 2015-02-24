couchpotato: python CouchPotato.py --data_dir {{ default .Env.CP_DATA_DIR "/data" }} --config_file {{ default .Env.CP_CONFIG "/data/settings.conf" }} --console_log
dnsmasq: dnsmasq -kd