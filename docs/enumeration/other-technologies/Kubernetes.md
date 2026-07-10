Lo primero y posiblemente más importante, cuando algo falla en Kubernetes, casi siempre cuesta depurar y hacerlo funcionar otra vez.  
  
Por ese motivo, lo mejor es desplegar los objetos y configuraciones en un entorno separado y probar ahí.  
  
Si haces pentesting sobre Kubernetes, ten claro que algún objeto o despliegue se puede quedar tocado, por eso siempre es mejor hacerlo sobre un entorno de pruebas.  
  
Problemas de seguridad comunes:
❌ Permisos demasiado amplios sobre los objetos desplegados  
❌ [**#RBAC**](https://www.linkedin.com/search/results/all/?keywords=%23rbac&origin=HASH_TAG_FROM_FEED) inexistente o poco estricto  
❌ Crear objetos y despliegues con el usuario kubernetes-admin o similar  
❌ No tener políticas de control de accesos en red sobre los [**#Deploys**](https://www.linkedin.com/search/results/all/?keywords=%23deploys&origin=HASH_TAG_FROM_FEED), [**#Services**](https://www.linkedin.com/search/results/all/?keywords=%23services&origin=HASH_TAG_FROM_FEED) y [**#Pods**](https://www.linkedin.com/search/results/all/?keywords=%23pods&origin=HASH_TAG_FROM_FEED)  
❌ Permitir que los Pods se ejecuten con todos los permisos por defecto, sin restricciones de seguridad.
