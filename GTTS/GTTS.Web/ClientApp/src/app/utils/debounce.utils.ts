
export function Debounce(wait: number = 250, when: FirstExecutionTime = FirstExecutionTime.LATER) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        var originalDescriptor = descriptor.value;

        descriptor.value = function () {
            var args: { [x: string]: any; } = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i - 0] = arguments[_i];
            }

            var instance = this;
            if (descriptor.value["DebounceTimeoutID"] == 0) {
                if (when == FirstExecutionTime.NOW) {
                    originalDescriptor.apply(instance, args);
                }
            }
            else {
                clearTimeout(descriptor.value["DebounceTimeoutID"]);
                descriptor.value["DebounceTimeoutID"] = 0;
            }

            descriptor.value["DebounceTimeoutID"] = setTimeout(() => {
                clearTimeout(descriptor.value["DebounceTimeoutID"]);
                descriptor.value["DebounceTimeoutID"] = 0;
                if (when == FirstExecutionTime.LATER) {
                    originalDescriptor.apply(instance, args);
                }
            }, wait);

            return null;
        };

        descriptor.value["DebounceTimeoutID"] = 0;
    };
};

export enum FirstExecutionTime {
    NOW,
    LATER
};