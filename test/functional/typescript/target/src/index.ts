// Example TypeScript API with different constructs and semver changes

// Enum example with added value (MINOR change)
export enum Status {
    Active = 'ACTIVE',
    Inactive = 'INACTIVE',
    Pending = 'PENDING',
    Archived = 'ARCHIVED' // Added new enum value
}

// Interface example with required property added (MAJOR change)
export interface User {
    id: string;
    name: string;
    status: Status;
    role: Role;
    email: string; // Added required property
}

// Union type with added option (MINOR change)
export type Role = 'admin' | 'user' | 'guest' | 'moderator';
export type Fn = (a: number, b?: string) => string;
export type Obj = {
    a: string,
    b: string | undefined,
    c?: number
}

// Class with various changes to methods and properties
export class UserService {
    private users: Map<string, User>;
    public apiVersion: string; // Added public property (MINOR change)

    // Constructor with parameter type change (MAJOR change)
    constructor(initialUsers: ReadonlyArray<User> = []) {
        this.apiVersion = '2.0.0';
        this.users = new Map();
    }

    // Public methods
    public addUser(user: User): string { // Return type changed from void to string (MAJOR change)
        return user.id;
    }

    // Method signature unchanged
    public getUser(id: string): User | undefined {
        return undefined;
    }

    // Parameter type changed (MAJOR change)
    public updateStatus(id: string, status: Status | string): boolean {
        return false;
    }

    // Static method with parameter reorder (MAJOR change)
    static createDefaultUser(name: string, id: string): User {
        return { id, name, status: Status.Pending, role: 'guest', email: 'default@example.com' };
    }

    // Method with optional parameters - added new optional parameter (MINOR change)
    public findUsers(options?: { status?: Status; role?: Role; active?: boolean }): User[] {
        return [];
    }

    // Method with rest parameters unchanged
    public deleteUsers(...ids: string[]): number {
        return 0;
    }
    
    // New public method (MINOR change)
    public exportUsers(): Record<string, User> {
        return {};
    }

    // Getter unchanged
    get userCount(): number {
        return 0;
    }
    
    // Added setter (MINOR change)
    set maxUsers(count: number) {
        // Implementation
    }
}

// Generic function with constraint added (MAJOR change)
export function filterItems<T extends Record<string, any>>(items: T[], predicate: (item: T) => boolean): T[] {
    return [];
}

// Function with function parameters - added parameter (MAJOR change)
export function processUsers(
    users: User[],
    processor: (user: User) => void,
    errorHandler: (error: Error) => void
): void {}

// Utility type usage with renamed type (MAJOR change)
export type UserPartialUpdate = Partial<User>;

// New exported constant (MINOR change)
export const API_VERSION = '2.0.0';

// base class is not directly exported, but is included transitively through ClassWithInheritance
class BaseClass {
    a = 1;
    b() { return 'a' }
    d = (a: string) => {}
}
export class ClassWithInheritance extends BaseClass {
    c = 2
}