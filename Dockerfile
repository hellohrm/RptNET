FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

RUN apt-get update \
    && apt-get install -y --allow-unauthenticated \
        libc6-dev \
        libgdiplus \
        libx11-dev \
     && rm -rf /var/lib/apt/lists/*

#https://forum.aspose.com/t/unable-to-find-an-entry-point-named-gdiplusstartup-in-dll-libgdiplus/207980/2

#WORKDIR /app

#FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
#WORKDIR /src
#COPY ["RptNET.csproj", "RptNET/"]
#RUN dotnet restore "RptNET/RptNET.csproj"
#WORKDIR "/src/RptNET"
#COPY . .
#RUN dotnet build "RptNET.csproj" -c Release -o /app/build
 
#FROM build AS publish
#RUN dotnet publish "RptNET.csproj" -c Release -o /app/publish
 
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .

#CMD ASPNETCORE_URLS=http://*:$PORT dotnet RptNET.dll
