Kubernetes Elasticsearch ve Kibana Kurulumu
Bu proje, Elasticsearch ve Kibana'nın Kubernetes üzerinde çalıştırılması için gerekli olan kaynakları içerir. Elasticsearch ve Kibana arasında sorunsuz bir bağlantı sağlamak için gereken Secrets, Persistent Volumes, Deployments, ve Jobs gibi kaynaklar bu projede yer almaktadır.

#   İçindekiler
## Secrets:
e-secret.yaml: Elasticsearch için gerekli kimlik bilgilerini içerir.
k-secret.yaml: Kibana için gerekli kimlik bilgilerini içerir.
## Persistent Volumes:
e-pv.yaml: Elasticsearch verilerini kalıcı olarak saklamak için kullanılır.
e-pvc.yaml: Elasticsearch için Persistent Volume Claim tanımı.
##  Deployments:
e-deploy.yaml: Elasticsearch Deployment tanımı.
k-deploy.yaml: Kibana Deployment tanımı.
##  Services:
e-service.yaml: Elasticsearch'ü erişilebilir hale getirir.
k-service.yaml: Kibana'yı erişilebilir hale getirir.
##  Job:
job.yaml: Kibana sistem kullanıcısının şifresini Elasticsearch üzerinde günceller.

### Gereksinimler
Kubernetes kümesinin doğru bir şekilde yapılandırılmış olması.
kubectl komut satırı aracının yüklenmiş ve Kubernetes kümesine bağlı olması.
Elasticsearch için kalıcı bir depolama alanı (Persistent Volume).
####    Kurulum Sırası
#####   1. Secrets'ları Oluşturma
Secrets, Elasticsearch ve Kibana için gerekli kimlik bilgilerini sağlar. İlk olarak bu dosyaları uygulayın:

```bash

kubectl apply -f e-secret.yaml
kubectl apply -f k-secret.yaml

```
#####   2. Elasticsearch'i Dağıtma
Elasticsearch için gerekli kaynakları sırasıyla dağıtın:

Persistent Volume ve Persistent Volume Claim'i oluşturun:

```bash
kubectl apply -f e-pv.yaml
kubectl apply -f e-pvc.yaml
```
#####   Elasticsearch Deployment'ını çalıştırın:

```bash
kubectl apply -f e-deploy.yaml
```
#####   Elasticsearch'ü erişilebilir hale getiren Service'i uygulayın:

```bash
kubectl apply -f e-service.yaml
```
#####   3. Kibana Şifresini Güncellemek için Job'u Çalıştırma
Kibana sistem kullanıcısının (kibana_system) Elasticsearch üzerindeki şifresini güncellemek için Job'u çalıştırın:

Job'u dağıtın:

```bash
kubectl apply -f job.yaml
```
#####   Job'un tamamlandığını kontrol edin:

```bash
kubectl get jobs
```
#####   Job loglarını kontrol ederek şifrenin başarıyla güncellenip güncellenmediğini doğrulayın:

```bash
kubectl logs <job-pod-name>
```
#####   4. Kibana'yı Dağıtma
Kibana, Job tarafından ayarlanan yeni şifreyle Elasticsearch'e bağlanmalıdır. Şimdi Kibana'yı dağıtabilirsiniz:

#####   Kibana Deployment'ını çalıştırın:

```bash
kubectl apply -f k-deploy.yaml
```
#####   Kibana'yı erişilebilir hale getiren Service'i uygulayın:

```bash
kubectl apply -f k-service.yaml
```
#####   5. Kibana ve Elasticsearch Bağlantısını Test Etme
Kibana'nın servis IP'sine veya DNS adresine erişin:

```bash
kubectl get svc
```
Kibana'ya tarayıcı üzerinden erişmek için NodePort veya LoadBalancer türüne bağlı olarak IP ve portu kullanın.

Kibana'da, Elasticsearch bağlantı durumunu kontrol edin.

######  Ek Kaynaklar
Test Uygulaması: Hello World
Kubernetes kümesini test etmek için bir örnek uygulama dağıtabilirsiniz:

Uygulamayı dağıtın:

```bash
kubectl apply -f hello-deploy.yaml
kubectl apply -f hello-service.yaml
```
Uygulamaya erişmek için ilgili servisin IP ve port bilgilerini kullanın.

Sorun Giderme
Job Hataları:

Eğer Job başarısız olursa, pod loglarını kontrol edin:
```bash
kubectl logs <job-pod-name>
```
Elasticsearch ve Kibana Bağlantı Sorunları:

Kibana pod'unda kibana.yaml dosyasını kontrol edin.
Doğru Elasticsearch URL'sinin ve kimlik bilgilerinin tanımlı olduğundan emin olun.
Service Erişim Problemleri:

Servis türünü (ClusterIP, NodePort, LoadBalancer) ve port yapılandırmalarını kontrol edin:
```bash
kubectl get svc
```
Persistent Volume Sorunları:

Depolama sınıfı ve disk izinlerini kontrol edin.

######  Sonuç
Bu adımları takip ederek Elasticsearch ve Kibana'yı Kubernetes üzerinde güvenli ve ölçeklenebilir bir şekilde çalıştırabilirsiniz. 