FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

RUN ln -s /lib/x86_64-linux-gnu/libdl-2.24.so /lib/x86_64-linux-gnu/libdl.so


#https://forum.aspose.com/t/unable-to-find-an-entry-point-named-gdiplusstartup-in-dll-libgdiplus/207980/2

WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["RptNET.csproj", "RptNET/"]
RUN dotnet restore "RptNET/RptNET.csproj"
WORKDIR "/src/RptNET"
COPY . .
RUN dotnet build "RptNET.csproj" -c Release -o /app/build
 
FROM build AS publish
RUN dotnet publish "RptNET.csproj" -c Release -o /app/publish
 
FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .

RUN ln -s /lib/x86_64-linux-gnu/libdl-2.24.so /lib/x86_64-linux-gnu/libdl.so
# install native dependencies
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated --no-install-recommends \
         apt-utils \
   	 libgdiplus \
         libx11-6 \
         libxext6 \
         libxrender1 \
      && curl -o /usr/lib/libwkhtmltox.so \
        --location \
        https://github.com/rdvojmoc/DinkToPdf/raw/v1.0.8/v0.12.4/64%20bit/libwkhtmltox.so

WORKDIR /app
COPY --from=build-env /app/out ./

CMD ASPNETCORE_URLS=http://*:$PORT dotnet RptNET.dll
