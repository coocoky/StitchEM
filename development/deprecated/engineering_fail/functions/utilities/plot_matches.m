function plot_matches(pointsA, pointsB, tile_size, overlap)
%PLOT_MATCHES Plots point matches on top of each other and displays some basic statistics on the matches.

%% Parameters
if nargin < 3
    tile_size = 8000;
end
if nargin < 4
    overlap = 0.1;
end

%% Adjust figure display
% Calculate effective block size considering tile overlap
block_size = tile_size * (1 - overlap);

% Infer which tiles of the section grid to show based on points
top_left = floor((min(min(pointsA), min(pointsB)) + repmat(overlap * tile_size, [1 2])) / block_size);
left = top_left(1); top = top_left(2);
bottom_right = ceil((max(max(pointsA), max(pointsB)) - repmat(overlap * tile_size, [1 2])) / block_size);
right = bottom_right(1); bottom = bottom_right(2);

% Show figure
figure, hold on

% Top-left of the plot should be (0, 0)
set(gca, 'YDir', 'reverse');
set(gca, 'XAxisLocation', 'top');

% Set the size of the figure to fit all the blocks
xlim([left * block_size, right * block_size])
ylim([top * block_size, bottom * block_size])

% Display grid with ticks at every block and seam
grid on
set(gca, 'XTick', sort([(left : right) * block_size, (left + 1 : right - 1) * block_size + tile_size * overlap]));
set(gca, 'YTick', sort([(top : bottom) * block_size, (top + 1 : bottom - 1) * block_size + tile_size * overlap]));

% Display tile labels as integers
x_ticks = num2str(get(gca, 'XTick')', '%d');
x_ticks(2:2:end, :) = repmat(' ', size(x_ticks(2:2:end, :)));
y_ticks = num2str(get(gca, 'YTick')', '%d');
y_ticks(2:2:end, :) = repmat(' ', size(y_ticks(2:2:end, :)));
set(gca, 'XTickLabel', x_ticks)
set(gca, 'YTickLabel', y_ticks)

%% Plot the point matches
% Plot the individual points
plot(pointsA(:, 1), pointsA(:, 2), 'rx');
plot(pointsB(:, 1), pointsB(:, 2), 'bx');

% Plot lines between point matches
for i = 1:size(pointsA, 1)
    x = [pointsA(i, 1) pointsB(i, 1)];
    y = [pointsA(i, 2) pointsB(i, 2)];
    plot(x, y, 'g-')
end

hold off

%% Display statistics on matches
% Get distances
distances = match_distances(pointsA, pointsB);

fprintf(['Match statistics:\n' ...
         '  n = %d matches\n' ...
         '  Mean = %f px\n' ...
         '  Median = %f px\n' ...
         '  Min = %f\n' ...
         '  Max = %f\n' ...
         '  STD = %f\n\n'], ...
         numel(distances), mean(distances), median(distances), ...
         min(distances), max(distances), std(distances))

end

