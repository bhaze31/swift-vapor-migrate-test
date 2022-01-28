import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import AutoMigrator

extension Environment {
    static var databaseURL: URL {
        guard let urlString = Environment.get("DATABASE_URL"), let url = URL(string: urlString) else {
            fatalError("DATABASE_URL not configured")
        }
        
        return url
    }
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if var config = PostgresConfiguration(url: Environment.databaseURL), app.environment.isRelease {
        config.tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        app.databases.use(.postgres(configuration: config), as: .psql)
    } else {
        try app.databases.use(.postgres(url: Environment.databaseURL), as: .psql)
    }

    app.migrations.add(CreateTodo())

    app.views.use(.leaf)

    app.loadAutoMigrations()

    // register routes
    try routes(app)
}
