local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.openshift4_proxy;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('openshift4-proxy', params.namespace);

{
  'openshift4-proxy': app,
}
