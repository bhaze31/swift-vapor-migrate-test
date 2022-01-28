import Fluent
import AutoMigrator

final class M20220128132332613_AddUser: AutoMigration {
    override var name: String { String(reflecting: self) }
    override var defaultName: String { String(reflecting: self) }
    
    override func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .field("testField", .string)
            .update()
    }

    override func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .deleteField("testField")
            .update()
    }
}
