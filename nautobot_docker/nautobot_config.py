import os

def is_truthy(value):
    return str(value).lower() in ['true', '1', 'yes']

# In your configuration.py
PLUGINS = ["nautobot_ssot", "nautobot_device_lifecycle_mgmt", "nautobot_bgp_models", "nautobot_plugin_nornir", "nautobot_device_onboarding", "nautobot_capacity_metrics", "nautobot_golden_config" ]

PLUGINS_CONFIG = {
  "nautobot_ssot": {
  },
  "nautobot_plugin_nornir": {
      "use_config_context": {"secrets": False, "connection_options": True},
      "connection_options": {
          "napalm": {
              "extras": {
                  "optional_args": {"global_delay_factor": 1},
              },
          },
          "netmiko": {
              "extras": {
                  "global_delay_factor": 1,
              },
          },
      },
      "nornir_settings": {
          "credentials": "nautobot_plugin_nornir.plugins.credentials.env_vars.CredentialsEnvVars",
          "runner": {
              "plugin": "threaded",
              "options": {
                  "num_workers": 20,
              },
          },
      }
    },
   "nautobot_capacity_metrics": {
     "app_metrics": {
         "gitrepositories": True,
         "jobs": True,
         "models": {
             "dcim": {
                 "Site": True,
                 "Rack": True,
                 "Device": True,
                 "Interface": True,
                 "Cable": True,
             },
             "ipam": {
                 "IPAddress": True,
                 "Prefix": True,
             },
             "extras": {
                 "GitRepository": True
             },
         },
         "queues": True,
         "versions": {
             "basic": True,
             "plugins": True,
         }
     }
  },
  "nautobot_golden_config": {
      "per_feature_bar_width": 0.15,
      "per_feature_width": 13,
      "per_feature_height": 4,
      "enable_backup": True,
      "enable_compliance": True,
      "enable_intended": True,
      "enable_sotagg": False,
      "enable_plan": True,
      "enable_deploy": True,
      "enable_postprocessing": False,
      "sot_agg_transposer": None,
      "postprocessing_callables": [],
      "postprocessing_subscribed": [],
      "jinja_env": {
          "undefined": "jinja2.StrictUndefined",
          "trim_blocks": True,
          "lstrip_blocks": False,
      },
      # "default_deploy_status": "Not Approved",
      # "get_custom_compliance": "my.custom_compliance.func"
  },
}