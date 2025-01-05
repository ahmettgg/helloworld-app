# İlk aşama: Build aşaması
FROM maven:3.8.7-openjdk-18-slim AS build
WORKDIR /build
# Bağımlılık yüklemesi ayrı bir katmanda olduğundan, pom.xml değişmediği sürece bağımlılıklar yeniden indirilmez.
COPY pom.xml .
# Maven bağımlılıklarını önceden indir.
RUN mvn dependency:go-offline -B  
COPY src ./src
# Projeyi build et
RUN mvn clean install

# İkinci aşama: Production aşaması
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Build aşamasından JAR dosyasını kopyala
COPY --from=build /build/target/*.jar app.jar
# Portu expose et
EXPOSE 8081
# Uygulamayı başlat
ENTRYPOINT ["java", "-jar", "app.jar"]

### Multi-Stage Build Kullanmanın Avantajları Maven bağımlılıkları, kaynak kodu ve build araçları üretim imajına dahil edilmez. 
### Bu, üretim imajının boyutunu küçültür ve güvenlik açıklarını azaltır. 