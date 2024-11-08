import adsk.core, adsk.fusion, adsk.cam, traceback
import csv

def run(context):
    ui = None
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface

        # Get the active design
        design = app.activeProduct
        if not isinstance(design, adsk.fusion.Design):
            ui.messageBox('Please run this script in the Fusion 360 design workspace.')
            return

        # Show the file selection dialog
        file_dialog = ui.createFileDialog()
        file_dialog.title = "Select CSV File"
        file_dialog.filter = "*.csv"
        dialog_result = file_dialog.showOpen()

        # Check if the user selected a file
        if dialog_result != adsk.core.DialogResults.DialogOK:
            ui.messageBox('No file was selected.')
            return

        # Get the file path
        csv_file_path = file_dialog.filename
        points = []
        conversion_factor = 0.1  # Converts mm to cm

        # Read points from the CSV file and apply the conversion factor
        with open(csv_file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                x = float(row['x']) * conversion_factor
                y = float(row['y']) * conversion_factor
                z = float(row['z']) * conversion_factor
                points.append(adsk.core.Point3D.create(x, y, z))

        # Create a new sketch on the XY plane
        root_comp = design.rootComponent
        sketch = root_comp.sketches.add(root_comp.xYConstructionPlane)

        # Add points to the sketch
        for point in points:
            sketch.sketchPoints.add(point)

        ui.messageBox('Points successfully added to the sketch.')

    except:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))