import os
import glob

def find_test_file(directory):
    # Search for files matching the pattern *_test.txt
    test_files = glob.glob(os.path.join(directory, '*_test.txt'))
    
    # If no matching file found, return None
    if not test_files:
        return None
    
    # If multiple files found, return the first one
    return test_files[0]


if __name__ == '__main__':
    
    # Example usage:
    directory = '/codehub/external/100-Driver-Source'
    test_file = find_test_file(directory)
    if test_file:
        print("Found test file:", test_file)
    else:
        print("No test file found.")
