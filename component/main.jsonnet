// main template for openshift4-proxy
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.openshift4_proxy;

local has_ca_bundle = params.trustedCA != null;
local ca_bundle_name = 'user-ca-bundle';
local ca_bundle = kube.ConfigMap(ca_bundle_name) {
  data: {
    'ca-bundle.crt': params.trustedCA,
  },
};

local spec = params.spec {
  httpProxy: params.httpProxy,
  httpsProxy: params.httpsProxy,
  [if std.length(params.noProxy) > 0 then 'noProxy']: std.join(',', params.noProxy),
  [if has_ca_bundle then 'trustedCA']: {
    name: ca_bundle_name,
  },
};
local proxy_config = kube._Object('config.openshift.io/v1', 'Proxy', 'cluster') {
  spec+: std.prune(spec),
};

// Define outputs below
{
  [if has_ca_bundle then ca_bundle_name]: ca_bundle,
  proxy_config: proxy_config,
}
