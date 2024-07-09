export 'location_service_stub.dart' // Fallback para otras plataformas
    if (dart.library.html) 'location_service_web.dart' // Importación para web
    if (dart.library.io) 'location_service_mobile.dart'; // Importación para móviles