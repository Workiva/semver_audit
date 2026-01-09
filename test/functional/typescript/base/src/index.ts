// Example TypeScript API with different constructs

// Enum example
export enum Status {
    Active = 'ACTIVE',
    Inactive = 'INACTIVE',
    Pending = 'PENDING'
}

// Interface example
export interface User {
    id: string;
    name: string;
    status: Status;
    role: Role;
}

// Union type
export type Role = 'admin' | 'user' | 'guest';
export type Fn = () => string;
export type Obj = {
    a: string,
    b: string | undefined,
}

// Class with various methods and properties
export class UserService {
    private users: Map<string, User>;

    // Constructor
    constructor(initialUsers: User[] = []) {}

    // Public methods
    public addUser(user: User): void {}

    public getUser(id: string): User | undefined {
        return undefined;
    }

    public updateStatus(id: string, status: Status): boolean {
        return false;
    }

    // Static method
    static createDefaultUser(id: string, name: string): User {
        return { id, name, status: Status.Pending, role: 'guest' };
    }

    // Method with optional parameters
    public findUsers(options?: { status?: Status; role?: Role }): User[] {
        return [];
    }

    // Method with rest parameters
    public deleteUsers(...ids: string[]): number {
        return 0;
    }

    // Getter
    get userCount(): number {
        return 0;
    }
}

// Generic function
export function filterItems<T>(items: T[], predicate: (item: T) => boolean): T[] {
    return [];
}

// Function with function parameters
export function processUsers(
    users: User[],
    processor: (user: User) => void
): void {}

// Utility type usage
export type UserUpdate = Partial<User>;


// base class is not directly exported, but is included transitively through ClassWithInheritance
class BaseClass {
    a = 1;
    b() { return 'a' }
}
export class ClassWithInheritance extends BaseClass {
    c = 2
}