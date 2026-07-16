[https://swisskyrepo.github.io/InternalAllTheThings/containers/kubernetes/](https://swisskyrepo.github.io/InternalAllTheThings/containers/kubernetes/)

First and foremost, when anything fails on Kubernetes, it is difficult to troubleshoot and make it work again.
  
That is why it is better to deploy objects and configurations in a separated environment and test there.
  
If you perform Kubernetes pentesting, you should know some objects or deployments can be affected and that is why it is better to pentest on a staging/test environment.
  
Common security issues:

❌ Too many permissions on deployed objects
❌ Inexistent [**#RBAC**](https://www.linkedin.com/search/results/all/?keywords=%23rbac&origin=HASH_TAG_FROM_FEED)  or too loose
❌ Create objects and deploys with kubernetes-admin user or similar  
❌ Do not have network access control policies over [**#Deploys**](https://www.linkedin.com/search/results/all/?keywords=%23deploys&origin=HASH_TAG_FROM_FEED), [**#Services**](https://www.linkedin.com/search/results/all/?keywords=%23services&origin=HASH_TAG_FROM_FEED) y [**#Pods**](https://www.linkedin.com/search/results/all/?keywords=%23pods&origin=HASH_TAG_FROM_FEED)  
❌ Allow pods can be executed with all permissions by default, without security restrictions.
