#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["vuedockerplayground.client/nuget.config", "vuedockerplayground.client/"]
COPY ["VueDockerPlayground.Server/VueDockerPlayground.Server.csproj", "VueDockerPlayground.Server/"]
COPY ["vuedockerplayground.client/vuedockerplayground.client.esproj", "vuedockerplayground.client/"]
RUN dotnet restore "./VueDockerPlayground.Server/./VueDockerPlayground.Server.csproj"
COPY . .
RUN apt-get update -yq 
RUN apt-get install curl gnupg -yq 
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
WORKDIR "/src/VueDockerPlayground.Server"
RUN dotnet build "./VueDockerPlayground.Server.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./VueDockerPlayground.Server.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VueDockerPlayground.Server.dll"]

#docker run --rm -p 8080:8080 --name pgcontainer pgimage
#docker run --rm -p 8080:8080 --name aspnetcorewebapicontainer aspnetcorewebapiimage